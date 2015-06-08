# encoding: utf-8
class WorkordersController < ApplicationController
  #redirect_to(request.referer), redirect_to(:back)
  layout "application", :except => [:remove_service,:filter]

  helper_method :sort_column,:sort_direction

  def destroy
    @wo = Workorder.find(params[:id])
    authorize! :destroy, @wo
    @wo.destroy

    respond_to do |format|
      format.html {redirect_to workorders_path}
      format.js { render :layout => false}
    end

  end

  def autopart
    page = params[:page] || 1
    per_page = 10

    filters_params = {}
    filters_params[:wo_status_id] = Status::OPEN_FOR_AUTOPART
    filters_params[:company_id] = current_user.company_active.id if current_user.user_type.blank? || current_user.user_type.service_center?

    @workorders = Workorder.find_by_params(filters_params)

    @count= @workorders.count()
    @work_orders = @workorders.paginate(:page =>page,:per_page =>per_page)
  end

  def index
    page = params[:page] || 1
    per_page = 10
    params.delete_if{|k,v| v.empty? || v == "-1"}
    
    @company_services = get_service_types

    @order_by = order_by

    @service_type_ids =  params[:service_type_ids] || [] #current_user.service_types.map(&:id)
    
    @status_id = params[:wo_status_id] if params[:wo_status_id] && params[:wo_status_id] != "-1"

    filters_params ={}
    @date_f = params[:date_from]
    @date_t =params[:date_to]
    @domain = params[:domain]
    @wo_id = params[:number]
    @material = params[:material]

    filters_params[:date_from] = @date_f if @date_f
    filters_params[:date_to] =  @date_t if @date_t
    filters_params[:domain] = @domain if @domain
    filters_params[:service_type_ids] = @service_type_ids 
    filters_params[:wo_status_id] = @status_id if @status_id
    params[:company_id] = company_id if company_id
    filters_params[:material] = @material if @material
    params[:user] = current_user
    filters_params[:workorder_id] = @wo_id if @wo_id 
    params[:order_by] = @order_by
    
    @filters_params_exp = params
    #@filters_params_exp[:user] = nil
    @workorders = Workorder.find_by_params(params)
    @material = nil;

    @count= @workorders.count()
    @work_orders = @workorders.paginate(:page =>page,:per_page =>per_page)

    @report_data = Workorder.group_by_service_type(params)
    @workorder_amount= @work_orders.sum(&:total_price)

    @price={}
    @report_data.each_pair do |k,v|
      @price[ServiceType.find(k).name] = v.to_f if k
    end

    @price_data = Workorder.build_graph_data(@report_data)
    @amt = Workorder.group_by_service_type(params,false)
    @count_material = Workorder.group_by_material(params,false)

    amt_material = Workorder.group_by_material(params)
    count_material = Workorder.group_by_material(params,false)
    @amt_material_data = Workorder.build_material_data(amt_material,count_material)


    @count_data = {}
    @amt.each_pair do |k,v|
      if k
        @count_data[ServiceType.find(k).name] = v
      end
    end

    @amt_data = Workorder.build_graph_data(@amt)

    @services_amount =0
    @amt.each{|key,value| @services_amount += value}


    available_custom_statuses = []
    company = get_company
    if company
      available_custom_statuses = company.available_custom_statuses.collect{|v| [v.name,v.id]}
    end

    @status = [[I18n.t("state"),"-1"]] + available_custom_statuses

    respond_to do |format|
      format.html
      format.js { render :layout => false}
   #   format.csv { render text: @workorders.to_csv}
   #   format.json {render text: @workorders.to_json}
    end
  end

  def export
    params[:user] = current_user

    csv = Workorder.workorder_report_to_csv params

    unless csv.empty?

      respond_to do |format|
        format.csv { send_data csv.encode("iso-8859-1"), :filename => "workordersReport.csv", :type => 'text/csv; charset=iso-8859-1; header=present'}
      end

    else
      flash[:alert] = t("Error")
      redirect_to workorders_path
    end
  end

  def show

    @work_order = Workorder.find params[:id]
    @rank =  @work_order.build_rank_for_user(current_user)
    @vehicle = @work_order.vehicle
    authorize! :read, @work_order

    respond_to do |format|
      format.html
      format.pdf {
        authorize! :pdf, @work_order

        prawnto :prawn => {
          :page_size => 'A4',
          :left_margin => 20,
          :right_margin => 20,
          :top_margin => 15,
          :bottom_margin => 15},
          :filename=>"orden_de_trabajo_#{@work_order.id}.pdf"

          render :layout => false
        }
    end
  end

  #print workorder for company
  def print
    @work_order = Workorder.find params[:id]
    @vehicle = @work_order.vehicle
    authorize! :print, @work_order

    respond_to do |format|
      format.pdf {
          prawnto :prawn => {
            :page_size => 'A4',
            :left_margin => 10,
            :right_margin => 10,
            :top_margin => 35,
            :bottom_margin => 15,
            :page_layout => :landscape},
          :filename=>"orden_de_trabajo_#{@work_order.id}.pdf"

        render :layout => false
        }
    end
  end

  def notify
    @work_order = Workorder.find params[:id]
    @user = @work_order.vehicle.user
    @vehicle = @work_order.vehicle
    respond_to do |format|
      format.html { render :file=>"work_order_notifier/notify",:layout => "emails" }
    end
  end

  # PUT /brands/1
  # PUT /brands/1.xml
  def update
    @work_order = Workorder.find(params[:id])
    authorize! :update, @work_order
    @work_order.status = Status::OPEN_FOR_AUTOPART if params['open_for_autopart'].present?
    
    company = get_company(params)
    @payment_methods = company.available_payment_methods
    
    if params[:workorder][:notes_attributes]
      params[:workorder][:notes_attributes]["0"][:user_id] = "#{current_user.id}"
      params[:workorder][:notes_attributes]["0"][:creator_id] = "#{current_user.id}"
    end

    company_id =  get_company_id(params) if (@work_order.company_id.nil? && @work_order.company_info.nil?)

    respond_to do |format|
    if @work_order.update_attributes(params[:workorder])
      @work_order.services.each{|service| service.tasks.clear}
      if params[:service_type_ids]
        @work_order.services.each do |service|
          unless params[:service_type_ids][service.service_type.id.to_s].nil?
            service.tasks << Task.find(params[:service_type_ids][service.service_type.id.to_s][:task_ids])
          end
        end
      end

      format.html { redirect_to(@work_order)}
    else
      @vehicle_service_offers = []
      @vehicle_service_offers = @work_order.find_vehicle_service_offer(company_id) if company_id
      @service_types = get_service_types
      @work_order.is_open_for_autopart? ? @open_for_autopart = true : @open_for_autopart = false 
      format.html { render :action => "edit" }
    end

    end
  end

  def edit
    @update_km = false
    @work_order= Workorder.find(params[:id])
    authorize! :update, @work_order

    @work_order.notes.build if @work_order.notes.empty?
    
    company = get_company(params)
    @payment_methods = company.available_payment_methods

    @service_types = current_user.service_types    

    @work_order.initialize_with_vehicle_service_offer(company_id)
    @company = @work_order.company

    @work_order.status == Status::OPEN_FOR_AUTOPART ? @open_for_autopart = true : @open_for_autopart = false
  end

  def create
    params[:workorder][:notes_attributes]["0"][:user_id] = "#{current_user.id}" if params[:workorder][:notes_attributes]

    @work_order = Workorder.new(params[:workorder])
    @work_order.status = Status::OPEN_FOR_AUTOPART if params['open_for_autopart'].present?

    authorize! :create, @work_order

    if (@work_order.company_id.nil? && @work_order.company_info.nil?)
      @work_order.company_id = company_id.id
    end
    @work_order.km = Vehicle.find(@work_order.vehicle.id).km
    @work_order.user = current_user

    @work_order.notes.first.creator = current_user unless @work_order.notes.empty?
    @work_order.notes.first.user = current_user unless @work_order.notes.empty?

    if @work_order.save
      if params[:service_type_ids]
        @work_order.services.all.each do |service|
          service.tasks << Task.find(params[:service_type_ids][service.service_type.id.to_s][:task_ids])
        end
      end
      redirect_to @work_order
    else
      @payment_methods = get_company(params).available_payment_methods
      @service_types = current_user.service_types
      @work_order.vehicle = Vehicle.find(params[:vehicle_id]) if (params[:vehicle_id])
      #@vehicle_service_offers = @work_order.find_vehicle_service_offer(company_id)
      @work_order.is_open_for_autopart? ? @open_for_autopart = true : @open_for_autopart = false
      render :action => 'new'
    end
  end

  def new
    @work_order = Workorder.new
    
    @open_for_autopart = false

    company = get_company(params)

    @work_order.company_info  = params[:c] if params[:c]

    #set company if it is not ComunidadBox
    @work_order.company = company if company.id != 1
    @work_order.notes.build

    # si no hay parametro de auto, no hay parametro de presupuesto tomo el primer auto del usuario registrado
    @work_order.vehicle = current_user.vehicles.first if (params[:vehicle_id].nil? && params[:b].nil?)

    # si viene un vehicle_id lo busco y se lo asigno a la orden de trabajo
    @work_order.vehicle = Vehicle.find(params[:vehicle_id]) if params[:vehicle_id]
     
    @work_order.initialize_with_vehicle_service_offer(company_id)

    @service_types = current_user.service_types_active

    @payment_methods = company ? company.available_payment_methods : []
    if @work_order.company.nil? and @work_order.company_info.nil?
      flash[:notice] ="Para registar un servicio debe seleccionar un prestador"
      redirect_to root_path
      return
    end

    # si hay parametro de budget lo busco e inicializo al WO con los datos del presupuesto
    if params[:b]
      budget = Budget.companies(current_user.company.user.company_ids).where("id = ? ",params[:b].to_i).first

      if budget
        # si no hay auto en el budget y no hay auto como parametro
        # si no hay usuario voy a crear nuevo cliente
        if budget.user.nil? && budget.vehicle.nil?
          redirect_to(new_client_path(:b => budget.id))
          return
        end

        if budget.user && budget.vehicle.nil?
          redirect_to(new_vehicle_path(user_id: budget.user.id,b: budget.id))
          return
        end

        @work_order.initialize_with_budget(budget)
      else
        flash[:notice] ="El presupuesto no pertenece a su empresa"
        redirect_to budgets_path
        return
      end
    end

    @update_km= @work_order.vehicle.update_km?
    authorize! :create, @work_order
 
    respond_to do |format|
      format.html
    end

  end

  def task_list
    @service_type = ServiceType.find(params[:service_type_id])
    respond_to do |format|
      format.js { render :layout => false}
    end
  end

  def price_offer
    @work_order = Workorder.find params[:id]
    @price_offer = PriceOffer.find_by_user_and_workorder current_user, @work_order
  end

  def save_price_offer

    if params['price_offer']['id'].present?
      @price_offer = PriceOffer.find params['price_offer']['id']
      @price_offer.assign_attributes(params['price_offer'])
    else
      @price_offer = PriceOffer.new(params['price_offer'])
      @price_offer.user = current_user
      @price_offer.workorder = Workorder.find params[:id]
      @price_offer.confirmed = false
    end

    if @price_offer.save
      redirect_to autopart_workorders_path
    else
      @work_order = Workorder.find params[:id]
      render :action => 'price_offer'
    end
  end

  #GET
  def price_offers
    @work_order = Workorder.find params[:id]
  end

  #POST
  def confirm_price_offer
    if params[:price_offer_selected_id].present?
      workorder = Workorder.find params[:id]
      workorder.confirm_price_offer(params[:price_offer_selected_id].to_i) if workorder.present?
    end
    redirect_to autopart_workorders_path
  end

  private

  def order_by
    params[:order_by] && (not Workorder::ORDER_BY.values.select{|v| v == params[:order_by]}.empty?) ? params[:order_by] : "workorders.performed desc"
  end

end
