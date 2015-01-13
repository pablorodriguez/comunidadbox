# encoding: utf-8
class VehiclesController < ApplicationController
  authorize_resource

  layout "application", :except => [:search,:find_models,:search_companies,:km]
  skip_before_filter :authenticate_user!,:only => [:find_models]

  # GET /vehicles
  # GET /vehicles.xml
  def index
    page = params[:page] || 1
    domain = (params[:domain].strip if params[:domain]) || "%"
    domain = "%" if domain.empty?

    per_page = 12

    if company_id
      @company_vehicles = Vehicle.companies(company_id)
    else
      @company_vehicles = current_user.vehicles
    end


    @company_vehicles = Vehicle.where("domain like ?",domain) if  domain != "%"

    @company_id = params[:company_id]
    @company_vehicles = @company_vehicles.order("domain asc").paginate(:page =>page,:per_page =>per_page)

    respond_to do |format|
      format.html # index.html.erb
      format.js { render :layout => false}
    end
  end

  def service_done
  end

  def find_models
    @models = Model.where("brand_id = ?",params[:brand_id]).order("name")
    respond_to do |format|
      format.js { render :layout => false}
    end
  end

  def km
    @vehicle = Vehicle.find(params[:id])
    @vehicle.kmUpdatedAt = Time.zone.now
    new_km = params[:vehicle][:km].to_i
    new_avg= params[:vehicle][:kmAverageMonthly].to_i

    @msg = ""
    # valido si cambio km o kmAverageMonthly
    if ((@vehicle.km == new_km) && (@vehicle.kmAverageMonthly == new_avg))
      @msg = "Debe ingresar nuevos valores para Kilometraje o Km Promedio Mensual"
      logger.debug "No cambio valores"
    end

    respond_to do |format|
      @vehicle.update_attributes(params[:vehicle]) if @msg == ""
      @vehicle.reload
      format.js { render :layout => false}
    end
  end

  def update_km_avg
    domain = params[:domain]
    new_value = params[:update_value].to_i
    vehicle = Vehicle.find_by_domain domain
    vehicle.kmAverageMonthly = new_value
    vehicle.save
    vehicle.update_events
    render :text => new_value
  end

  def my
    page = params[:page] || 1
    @companies = Company.best current_user.state
    if params[:id]
      @user = User.find params[:id]
    else
      @user = current_user
    end
    @vehicles = @user.vehicles.paginate(:per_page=>15,:page =>page)
  end

  # GET /vehicles/1
  # GET /vehicles/1.xml
  def show
    @vehicle = Vehicle.find(params[:id])
    @company_services = get_service_types
    @service_type_ids =  params[:service_type_ids] || []
    @all_service_type = params[:all_service_type]

    authorize! :read, @vehicle
    @json = []
    @vehicle_id = params[:id]
    @usr = @vehicle.user.id
    @date_f = params[:date_from]
    @date_t =params[:date_to]

    page = params[:page] || 1
    data = params[:d] || "all"
    filters ={}

    filters[:service_type_ids] = @service_type_ids unless (@service_type_ids.empty?)
    filters[:order_by] = "workorders.performed DESC"
    filters[:date_from] = @date_f if (@date_f && (!@date_f.empty?))
    filters[:date_to] =  @date_t if (@date_t && (!@date_t.empty?))


    @notes = @vehicle.notes.paginate(:per_page=>10,:page =>1)
    per_page = 10
    respond_to do |format|

    if data == "all"
      filters[:domain] = @vehicle.domain
      filters[:user] = current_user unless company_id
      @work_orders = Workorder.find_by_params(filters).paginate(:per_page=>per_page,:page =>page)

      @budgets = @vehicle.budgets_for(current_user).paginate(:per_page=>10,:page=>1)
      @price_data = Workorder.build_graph_data(Workorder.group_by_service_type(filters))

      amt_material = Workorder.group_by_material(filters)
      count_material = Workorder.group_by_material(filters,false)

      @amt_material_data = Workorder.build_material_data(amt_material,count_material)

      @amt = Workorder.group_by_service_type(filters,false)
      @amt_data = Workorder.build_graph_data(@amt)

      @count_data = {}
      @amt.each_pair do |k,v|
        if k
          @count_data[ServiceType.find(k).name] = v
        end
      end


      @services_amount =0
      @amt.each{|key,value| @services_amount += value}

      @companies = Company.best(current_user.state)


      @events = @vehicle.future_events.paginate(:per_page=>per_page,:page =>page)
      @wo_pages = {:d=>"wo"}
      @e_pages = {:d=>"e"}
      format.html # show.html.erb
      format.js { render "all",:layout => false}
    end
    if data == "e"
      @events = @vehicle.future_events.paginate(:per_page=>10,:page =>page)
      @e_pages = {:d =>"e"}
      format.js { render "events",:layout => false}
    end

    if data =="wo"
      @work_orders = Workorder.for_vehicle(@vehicle_id).paginate(:per_page=>per_page,:page =>page,:order =>"performed desc")
      @wo_pages = {:d => "wo"}
      format.js { render "work_orders",:layout => false}
    end
    end
  end

  def search_companies
    @companies = Company.search params
    @vehicle_id = params[:vehicle_id]
    respond_to do |format|
      format.js { render :layout => false}
    end
  end

  # GET /vehicles/new
  # GET /vehicles/new.xml
  def new
    @vehicle = Vehicle.new
    if params[:user_id]
      user = User.find params[:user_id]
    else
      user=current_user
    end

    if params[:b].present?
      @budget = Budget.find(params[:b])
      flash.now.notice ="Antes de registrar un servicio por favor cree el Automovil"
      @vehicle.brand = @budget.brand
      @vehicle.model = @budget.model
      @vehicle.domain = @budget.domain
    end


    @vehicle.user = user
    @models = Array.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vehicle }
    end
  end

  # GET /vehicles/1/edit
  def edit
    @vehicle = Vehicle.find(params[:id])
    authorize! :update, @vehicle
    @models = Model.find_by_brand_id(@vehicle.brand.id)
    respond_to do |format|
      format.html
    end
  end

  # POST /vehicles
  # POST /vehicles.xml
  def create
    @vehicle = Vehicle.new(params[:vehicle])
    @vehicle.company = get_company
    parameters = {:vehicle_id => @vehicle.id}
    if params[:budget_id]
      parameters[:b] = params[:budget_id]
      b =Budget.find params[:budget_id]

    end

    respond_to do |format|
      if @vehicle.save
        if b
          b.vehicle = @vehicle
          b.save
        end
        format.html { redirect_to(new_workorder_path(:b=>b))} if b

        format.html { redirect_to(new_workorder_path(:vehicle_id=>@vehicle))} if current_user.is_employee?

        format.html { redirect_to(my_vehicles_path)} unless current_user.is_employee?
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /vehicles/1
  # PUT /vehicles/1.xml
  def update
    @vehicle = Vehicle.find(params[:id])

    respond_to do |format|
      if @vehicle.update_attributes(params[:vehicle])
        @vehicle.update_events
        format.html { redirect_to(@vehicle) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vehicle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicles/1
  # DELETE /vehicles/1.xml
  def destroy
    @vehicle = Vehicle.find(params[:id])
    authorize! :destroy, @vehicle

    @vehicle.destroy

    respond_to do |format|
      format.html { redirect_to(vehicles_url) }
      format.js { render :layout => false}
    end
  end

end
