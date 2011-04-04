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
    
    
    if current_user.company
      @workorders = Workorder.where("workorders.company_id = ?",current_user.company.id)
    else
      cars_ids = Array.new
      current_user.cars.each{|c| cars_ids << c.id}
      @workorders = Workorder.where("car_id in (?)",cars_ids)
    end

    unless params[:date_from].empty? && params[:date_to].empty?
      date_f = params[:date_from].to_datetime
      @date_f = params[:date_from]
      date_t = params[:date_to].to_datetime
      @date_t = params[:date_to]
      @workorders = @workorders.where("workorders.created_at between ? and ? ",date_f.in_time_zone,date_t.in_time_zone)
    else
      @date_f = nil
      @date_t = nil
    end

    unless params[:domain].empty?
      @workorders= @workorders.includes(:car).where("cars.domain like ?",params[:domain].upcase)
    else
      @domain = nil
    end

    unless params[:service_type][:id] == ""
      @workorders = @workorders.includes(:services).where("services.service_type_id = ?",params[:service_type][:id])
    end

    @work_orders = @workorders.paginate(:page =>page,:per_page =>per_page)  
  end

  def index
    page = params[:page] || 1
    per_page = 10
    @sort_column = sort_column
    @direction = sort_direction
    order_by = @sort_column + " " + @direction
    
    if current_user.company
      @work_orders = Workorder.paginate(:all,:page => page,:per_page=>per_page,:include =>:car,:order =>order_by,:conditions =>["workorders.company_id = ?",current_user.company.id])
    else
      cars_ids = Array.new
      current_user.cars.each{|c| cars_ids << c.id}
      @work_orders = Workorder.paginate(:all,:page => page,:per_page=>per_page,:include =>:car,:order =>order_by,:conditions =>["car_id in (?)",cars_ids])
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
      @service_types = CompanyService.find(:all,:conditions=>["company_id= ?",current_user.current_company.id],
        :joins=>:service_type,:order =>'service_types.name').collect{|p| p.service_type}
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

