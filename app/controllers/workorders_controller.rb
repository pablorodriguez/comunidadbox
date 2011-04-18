class WorkordersController < ApplicationController
  #redirect_to(request.referer), redirect_to(:back)

  layout "application", :except => [:remove_service,:filter]

  STATUS = ['Abierto','En Proceso','Cancelado','Terminado']

  helper_method :sort_column,:sort_direction

  def destroy
    Workorder.find(params[:id]).destroy
    redirect_to :action => 'index'
  end

  def remove_service
    @id= params[:id]
    @work_order = session[:work_order]
    @work_order.remove_service @id.to_i
  end
  
  def filter
    page = params[:page] || 1
    per_page = 10
    @sort_column = sort_column
    @direction = sort_direction
    order_by = @sort_column + " " + @direction
    
    logger.info "### date from [#{params[:date_from]}] is it null #{params[:date_from].nil?} is it empty #{params[:date_from].empty?}"
    logger.info "### date to [#{params[:date_to]}] is it null #{params[:date_to].nil?} is it empty #{params[:date_to].empty?}"
    
    date_from = params[:date_from].empty? ? nil : params[:date_from]
    date_to = params[:date_to].empty? ? nil : params[:date_fo]
    service_type_id = nil
    logger.info "### date from [#{date_from}] date to [#{date_to}]"
    
    @filters = Hash.new
    unless params[:service_type][:id].empty?
      @filters[:service_type_id] = (params[:service_type][:id])
    end
    @filters[:user] = current_user
    @filters[:domain] = params[:domain]
    
    unless params[:date_from].empty?
       @filters[:date_from] = params[:date_from]
    end   
    unless params[:date_to].empty?
       @filters[:date_to] = params[:date_to]
    end  
      
    @workorders = Workorder.find_by_params(@filters)
    @work_orders = @workorders.paginate(:page =>page,:per_page =>per_page)  
  end

  def index
    page = params[:page] || 1
    
    logger.info "### page #{params[:page]}"
    per_page = 5
    @sort_column = sort_column
    @direction = sort_direction
    order_by = @sort_column + " " + @direction
    if params[:service_type]
      service_type_id = params[:service_type][:id]
    end
    
    if params[:service_type_id]
      service_type_id = params[:service_type_id]
    else
      service_type_id = nil
    end
    
    
    date_from = params[:date_from] ? nil : params[:date_from]
    date_to = params[:date_to] ? nil : params[:date_fo]
      
    @workorders = Workorder.find_by_params(:date_from => date_from,:date_to =>date_to,
      :domain => params[:domain], :service_type_id => service_type_id ,:user => current_user)    
    @work_orders = @workorders.paginate(:page =>page,:per_page =>per_page)  
    respond_to do |format|
      format.html
      format.js { render :layout => false}
    end
  end

  def show
    @work_order = Workorder.find params[:id]
    @car = @work_order.car
    respond_to do |format|
      format.html
      format.pdf { render :layout => false }
    end
    
  end

  # PUT /brands/1
  # PUT /brands/1.xml
  def update
    @work_order = Workorder.find(params[:id])
    
    respond_to do |format|
      if @work_order.update_attributes(params[:workorder])
        flash[:notice] = 'Orden de Trabajo actualizada'
        if @work_order.finish?
          @work_order.generate_events
          send_notification @work_order.id          
        end
        format.html { redirect_to(@work_order) }
        format.xml  { head :ok }
      else
        @service_types = CompanyService.find(:all,
          :conditions=>["company_id= ?",current_user.company.id],
          :joins=>:service_type,:order =>'service_types.name').collect{|p| p.service_type}

        format.html { render :action => "edit" }
        format.xml  { render :xml => @work_order.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @work_order= Workorder.find(params[:id])
    @service_types = current_user.service_types
  end

  def create
    @work_order = Workorder.new(params[:workorder])
    #@work_order.company = current_user.current_company
    @work_order.user = current_user
    saveAction =false
    Workorder.transaction do
      car = @work_order.car
      car.company = current_user.current_company
      car.save
      saveAction = @work_order.save
      @work_order.generate_events
    end

    if saveAction
      if @work_order.finish?
        
        send_notification @work_order.id
      end

      flash[:notice] = "Orden de Trabajo creada correctamente"
      redirect_to @work_order.car
    else
      flash[:notice] = "No se pudo grabar la Orden de Trabajo"
      @service_types = current_user.service_types
      @work_order.car = Car.find(params[:car_id]) if (params[:car_id])
      render :action => 'new'
    end
  end
  
  def new
    company_id = params[:company_id]
    car_id = params[:car_id]
    if (car_id)
      car =Car.find(params[:car_id])
    else
      if current_user.cars.size == 1
        car = current_user.cars[0]
      else
        flash[:notice] = "Por favor seleccione un automovil"
        redirect_to cars_path(:company_id =>company_id)
      end
    end
    
    if current_user.company
      company_id = current_user.company.id
    end
    if company_id
      @work_order = Workorder.new
      if current_user.company
        company_service_id = current_user.company.id
      else
        company_service_id = Company::DEFAULT_COMPANY_ID
      end
      @work_order.company = Company.find company_id
      @work_order.car = car
      
      @service_types = current_user.service_types
    else
      flash[:notice] ="Por favro seleccione un prestador de servicios"
      redirect_to all_companies_path(:car_id =>car_id)
    end
  end

  private
  
  def send_notification(work_order_id)
    work_order = Workorder.find work_order_id
    message = WorkOrderNotifier.delay.notify(work_order)
    #message.deliver
    puts "########### work order enviada #{work_order.id} a #{work_order.user.email}"
    #worker = MiddleMan.worker(:mailer_worker)
    #worker.async_work_order_notification(:args => work_order_id)
    
  end
  
  def sort_column
    params[:sort] || "cars.domain"
  end

  def sort_direction
    if params[:direction]
      %[asc desc].include?(params[:direction])? params[:direction] : "asc"
    else
      "asc"
    end
  end
end

