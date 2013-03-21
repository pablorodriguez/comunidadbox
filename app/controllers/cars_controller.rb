class CarsController < ApplicationController

  authorize_resource

  layout "application", :except => [:search,:find_models,:search_companies,:km] 
  skip_before_filter :authenticate_user!,:only => [:find_models]
   
  # GET /cars
  # GET /cars.xml
  def index
    page = params[:page] || 1
    domain = (params[:domain].strip if params[:domain]) || "%"
    domain = "%" if domain.empty?
     
    @user = current_user
    per_page = 12
    
    if company_id
      @company_cars = Car.companies(company_id)
    else
      @company_cars = current_user.cars
    end
    
    
    @company_cars = Car.where("domain like ?",domain) if  domain != "%"

    @company_id = params[:company_id]
    @company_cars = @company_cars.order("domain asc").paginate(:page =>page,:per_page =>per_page)
    
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
    @car = Car.find(params[:id])
    @car.kmUpdatedAt = Time.zone.now
    new_km = params[:car][:km].to_i
    new_avg= params[:car][:kmAverageMonthly].to_i
    
    @msg = ""
    # valido si cambio km o kmAverageMonthly
    if ((@car.km == new_km) && (@car.kmAverageMonthly == new_avg))
      @msg = "Debe ingresar nuevos valores para Kilometraje o Km Promedio Mensual"
      logger.debug "No cambio valores"
    end

    respond_to do |format|
      @car.update_attributes(params[:car]) if @msg == ""
      @car.reload
      format.js { render :layout => false}
    end
  end

  def update_km_avg
    domain = params[:domain]
    new_value = params[:update_value].to_i
    car = Car.find_by_domain domain
    car.kmAverageMonthly = new_value
    car.save
    car.update_events
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
    @cars = @user.cars.paginate(:per_page=>15,:page =>page)
  end
  
  # GET /cars/1
  # GET /cars/1.xml
  def show
    @car = Car.find(params[:id])
    authorize! :read, @car
    @json = []
    @car_id = params[:id]
    @usr = @car.user.id
    page = params[:page] || 1
    data = params[:d] || "all"
    filters ={}
    
    @notes = @car.notes.paginate(:per_page=>10,:page =>1)
    per_page = 10
    respond_to do |format|
      
    if data == "all"
      @work_orders = Workorder.for_car(@car_id).paginate(:per_page=>per_page,:page =>page)
      filters[:domain] = @car.domain      
      filters[:user] = current_user unless company_id

      @budgets = @car.budgets.paginate(:per_page=>10,:page=>1)
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
      
      
      @events = @car.future_events.paginate(:per_page=>per_page,:page =>page)
      @wo_pages = {:d=>"wo"}
      @e_pages = {:d=>"e"}
      format.html # show.html.erb
      format.js { render "all",:layout => false} 
    end
    if data == "e"
      @events = @car.future_events.paginate(:per_page=>10,:page =>page)
      @e_pages = {:d =>"e"}
      format.js { render "events",:layout => false}        
    end
    
    if data =="wo"
      @work_orders = Workorder.for_car(@car_id).paginate(:per_page=>per_page,:page =>page,:order =>"performed desc")
      @wo_pages = {:d => "wo"}      
      format.js { render "work_orders",:layout => false}
    end
    end
  end

  def search_companies   
    @companies = Company.search params
    @car_id = params[:car_id]
    respond_to do |format|
      format.js { render :layout => false}
    end
  end

  # GET /cars/new
  # GET /cars/new.xml
  def new
    @car = Car.new
    if params[:user_id]
      user = User.find params[:user_id]
    else
      user=current_user
    end
       
    if params[:b].present?
      @budget = Budget.find(params[:b])
      flash.now.notice ="Antes de registrar un servicio por favor cree el Automovil"
      @car.brand = @budget.brand
      @car.model = @budget.model
      @car.domain = @budget.domain
    end

    
    @car.user = user
    @models = Array.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @car }
    end
  end

  # GET /cars/1/edit
  def edit
    @car = Car.find(params[:id])
    authorize! :update, @car
    @models = Model.find_by_brand_id(@car.brand.id)
    respond_to do |format|
      format.html
    end
  end

  # POST /cars
  # POST /cars.xml
  def create
    @car = Car.new(params[:car])
    @car.company = get_company
    parameters = {:car_id => @car.id}
    if params[:budget_id]
      parameters[:b] = params[:budget_id]
      b =Budget.find params[:budget_id]

    end

    respond_to do |format|
      if @car.save
        if b
          b.car = @car
          b.save
        end
        #flash[:notice] = t :car_created_exit        
        format.html { redirect_to(new_workorder_path(:b=>b))} if b
        format.html { redirect_to(new_workorder_path(:car_id=>@car))} unless b
        format.xml  { render :xml => @car, :status => :created, :location => @car }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @car.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cars/1
  # PUT /cars/1.xml
  def update
    @car = Car.find(params[:id])
    
    respond_to do |format|
      if @car.update_attributes(params[:car])
        @car.update_events
        flash[:notice] = t :car_updated_exit
        format.html { redirect_to(@car) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @car.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1
  # DELETE /cars/1.xml
  def destroy
    @car = Car.find(params[:id])
    @car.destroy

    respond_to do |format|
      format.html { redirect_to(cars_url) }
      format.xml  { head :ok }
    end
  end
  
end
