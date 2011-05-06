class WorkordersController < ApplicationController
  #redirect_to(request.referer), redirect_to(:back)

  layout "application", :except => [:remove_service,:filter]

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
  
  def index
    page = params[:page] || 1
    @company_services = current_user.company.company_service.map{|s| s.service_type}
    per_page = 10
    @sort_column = sort_column
    @direction = sort_direction
    order_by = @sort_column + " " + @direction
    
    date_from = (params[:date_from] && (!params[:date_from].empty?)) ? params[:date_from] : ""
    date_to = (params[:date_to] && (!params[:date_to].empty?)) ? params[:date_to] : ""
    domain = params[:domain] ? params[:domain] : ""
    service_type_id = (params[:service_type_id] && !(params[:service_type_id].empty?)) ? params[:service_type_id] : ""
    
    @filters = {:date_from => date_from,:date_to =>date_to,:domain => domain, 
        :service_type_id => service_type_id ,:user => current_user}
    logger.info "### Filtros #{@filters.inspect}"
    
    @workorders = Workorder.find_by_params(@filters)    
    @work_orders = @workorders.order(order_by).paginate(:page =>page,:per_page =>per_page)
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
    @work_order.km = Car.find(@work_order.car.id).km
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
        logger.info "### Work order finished"
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
      flash[:notice] ="Por favor seleccione un prestador de servicios"
      redirect_to all_companies_path(:car_id =>car_id)
    end
  end

  private
  
  def send_notification(work_order_id)
    Resque.enqueue WorkorderJob,work_order_id
    logger.info "### envio de notificacion"
  end
  
  def sort_column
    params[:sort] || "performed"
  end

  def sort_direction
    if params[:direction]
      %[asc desc].include?(params[:direction])? params[:direction] : "asc"
    else
      "desc"
    end
  end
end

