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

  def index
    page = params[:page] || 1
    per_page = 10

    @company_services = get_service_types 
    
    @order_by = order_by
    @service_type_ids =  params[:service_type_ids] || []
    @all_service_type = @service_type_ids.size > 0 ? true : false
    
    @status_id = params[:wo_status_id] if params[:wo_status_id] && (!params[:wo_status_id].empty?) && (params[:wo_status_id] != "-1")
        
    filters_params ={}
    @date_f = params[:date_from]
    @date_t =params[:date_to]
    @domain = params[:domain] || ""

    filters_params[:date_from] = @date_f if (@date_f && (!@date_f.empty?))
    filters_params[:date_to] =  @date_t if (@date_t && (!@date_t.empty?))
    filters_params[:domain] = @domain
    filters_params[:service_type_ids] = @service_type_ids unless (@service_type_ids.empty?)
    filters_params[:wo_status_id] = @status_id if @status_id
    filters_params[:company_id] = company_id if company_id
    filters_params[:user] = current_user
    @workorders = Workorder.find_by_params(filters_params)
    @report_data = Workorder.group_by_service_type(filters_params)

    @price={}
    @report_data.each_pair do |k,v|
      @price[ServiceType.find(k).name] = v if k
    end    

    @price_data = Workorder.build_graph_data(@report_data)
    @amt = Workorder.group_by_service_type(filters_params,false)
    @count_material = Workorder.group_by_material(filters_params,false)

    amt_material = Workorder.group_by_material(filters_params)
    count_material = Workorder.group_by_material(filters_params,false)
    @amt_material_data = Workorder.build_material_data(amt_material,count_material)
    
    
    @count_data = {}
    @amt.each_pair do |k,v|
      if k
        @count_data[ServiceType.find(k).name] = v
      end
    end

    @amt_data = Workorder.build_graph_data(@amt)
    @work_orders = @workorders.order(@order_by).paginate(:page =>page,:per_page =>per_page)

    @count= @workorders.count()
    @workorder_amount= @workorders.sum("price * amount")
    @services_amount =0
    @amt.each{|key,value| @services_amount += value}
    @status = {-1=>"-- Estado --"}.merge!(Status::WO_STATUS).collect{|v,k| [k,v]}

    respond_to do |format|
      format.html
      format.js { render :layout => false}
      format.csv { render text: "@work_orders.to_csv"}
    end
  end


  def show

    @work_order = Workorder.find params[:id]
    @car = @work_order.car
    authorize! :read, @work_order

    respond_to do |format|
      format.html
      format.pdf {
        prawnto :prawn => {
        :page_size => 'A6',
        :left_margin => 20,
        :right_margin => 20,
        :top_margin => 15,
        :bottom_margin => 15},
        :filename=>"orden_de_trabajo_#{@work_order.id}.pdf"

        render :layout => false
        }
    end
  end

  def print
    @work_order = Workorder.find params[:id]
    @car = @work_order.car
    authorize! :read, @work_order

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
    @user = @work_order.car.user
    @car = @work_order.car
    respond_to do |format|
      format.html { render :file=>"work_order_notifier/notify",:layout => "emails" }
    end
  end

  # PUT /brands/1
  # PUT /brands/1.xml
  def update
    @work_order = Workorder.find(params[:id])
    authorize! :update, @work_order
    if params[:workorder][:notes_attributes]
      params[:workorder][:notes_attributes]["0"][:user_id] = "#{current_user.id}" 
      params[:workorder][:notes_attributes]["0"][:creator_id] = "#{current_user.id}"
    end
    
    cso_ids = params["cso_ids"] || []

    if (@work_order.company_id.nil? && @work_order.company_info.nil?)
      company_id =  get_company_id(params)
    end

    respond_to do |format|
    if @work_order.update_attributes(params[:workorder])
      CarServiceOffer.update_with_services(@work_order.services,cso_ids)
      if @work_order.is_finished?
        #@work_order.generate_events
        @work_order.reload
        @work_order.regenerate_events
        send_notification @work_order.id
      end

      @work_order.services.all.each do |service|
        service.tasks.clear
      end

      if params[:service_type_ids]
        @work_order.services.all.each do |service|
          unless params[:service_type_ids][service.service_type.id.to_s].nil?
            service.tasks << Task.find(params[:service_type_ids][service.service_type.id.to_s][:task_ids])
          end
        end
      end

      format.html { redirect_to(@work_order)}
    else
      logger.debug "######################################## #{@work_order.errors}"
      @car_service_offers = []
      @car_service_offers = @work_order.find_car_service_offer(company_id) if company_id
      @service_types = get_service_types
      format.html { render :action => "edit" }
    end

    end
  end

  def edit
    @update_km = false
    @work_order= Workorder.find(params[:id])
    authorize! :update, @work_order

    @work_order.notes.build if @work_order.notes.empty?

    @service_types = current_user.service_types    

    @car_service_offers = @work_order.car_service_offers
    @company = @work_order.company
    if ((@car_service_offers.size == 0) && (@company))
      @car_service_offers = @work_order.find_car_service_offer(@company.id)
    end

  end

  def create
    params[:workorder][:notes_attributes]["0"][:user_id] = "#{current_user.id}" if params[:workorder][:notes_attributes]
    
    @work_order = Workorder.new(params[:workorder])
    authorize! :create, @work_order
    
    cso_ids = params["cso_ids"] || []

    if (@work_order.company_id.nil? && @work_order.company_info.nil?)
      @work_order.company_id = company_id.id 
    end
    @work_order.km = Car.find(@work_order.car.id).km
    @work_order.user = current_user
    
    @work_order.notes.first.creator = current_user unless @work_order.notes.empty?
    @work_order.notes.first.user = current_user unless @work_order.notes.empty?
    
    saveAction =false

    car = @work_order.car
    unless car.user.service_centers.map(&:id).include?(@work_order.company_id)
      comp = Company.find_by_id(@work_order.company_id)
      car.user.service_centers << comp if comp
    end

    CarServiceOffer.update_with_services(@work_order.services,cso_ids)
    saveAction = @work_order.save
    if @work_order.is_finished?
      #@work_order.generate_events
      # @work_order.reload      
      send_notification @work_order.id
    end

    if saveAction
      if params[:service_type_ids]
        @work_order.services.all.each do |service|
          service.tasks << Task.find(params[:service_type_ids][service.service_type.id.to_s][:task_ids])
        end
      end

      redirect_to @work_order
    else
      @service_types = current_user.service_types
      @work_order.car = Car.find(params[:car_id]) if (params[:car_id])
      @car_service_offers = @work_order.find_car_service_offer(company_id)
      render :action => 'new'
    end
  end

  def new
    @work_order = Workorder.new
    company = get_company(params)
    
    @work_order.performed = I18n.l(Time.zone.now.to_date)
    @work_order.company_info  = params[:c] if params[:c]
    
    @work_order.company = company if company
    @work_order.notes.build

    # si no hay parametro de auto, no hay parametro de presupuesto tomo el primer auto del usuario registrado
    @work_order.car = current_user.cars.first if (params[:car_id].nil? && params[:b].nil?)
    
    # si viene un car_id lo busco y se lo asigno a la orden de trabajo    
    @work_order.car = Car.find(params[:car_id]) if params[:car_id]    

    @service_types = current_user.service_types
       
    if @work_order.company.nil? and @work_order.company_info.nil?
      flash[:notice] ="Para registar un servicio debe seleccionar un prestador"
      redirect_to root_path
      return
    end

    # si hay parametro de budget lo busco e inicializo al WO con los datos del presupuesto
    if params[:b]
      budget = Budget.companies(current_user.company_ids).where("id = ? ",params[:b].to_i).first

      if budget
        # si no hay auto en el budget y no hay auto como parametro      
        # si no hay usuario voy a crear nuevo cliente
        if budget.user.nil? && budget.car.nil?
          redirect_to(new_client_path(:b => budget.id))
          return
        end
      
        if budget.user && budget.car.nil?
          redirect_to(new_car_path(user_id: budget.user.id,b: budget.id))
          return
        end

        @work_order.initialize_with_budget(budget)
      else
        flash[:notice] ="El presupuesto no pertenece a su empresa"
        redirect_to budgets_path
        return
      end
    end
    
    @car_service_offers =[]
    #busco las ofertas de servicios para el auto asignado a la orden de trabajo
    @car_service_offers = @work_order.find_car_service_offer(company.id)  if company
    @update_km= @work_order.car.update_km?
    #authorize! :create, @work_order
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

  private

  def send_notification(work_order_id)
    work_order = Workorder.find work_order_id
    if work_order.car.domain == "HRJ549"
      logger.info "### envio de notificacion mail #{work_order.id} Car: #{work_order.car.domain}"
      #message = WorkOrderNotifier.notify(work_order).deliver
      Resque.enqueue WorkorderJob,work_order_id
    end

  end

  def order_by
    params[:order_by] && (not Workorder::ORDER_BY.values.select{|v| v == params[:order_by]}.empty?) ? params[:order_by] : "workorders.performed desc"
  end

  


end

