class WorkordersController < ApplicationController
  #redirect_to(request.referer), redirect_to(:back)

  prawnto :prawn => {:page_size => "A4"}
  
  layout "application", :except => [:remove_service,:filter]

  helper_method :sort_column,:sort_direction

  def destroy
    wo = Workorder.find(params[:id])
    car = wo.car
    wo.destroy
    redirect_to car
  end

  def remove_service
    @id= params[:id]
    @work_order = session[:work_order]
    @work_order.remove_service @id.to_i
  end
  
  def index
    page = params[:page] || 1
    if current_user.company
      @company_services = current_user.company.service_type
    else
      @company_services = current_user.service_types
    end
    
    per_page = 8
    @sort_column = sort_column
    @direction = sort_direction
    order_by = @sort_column + " " + @direction
    
    @filters_params ={}
    
    @filters_params[:date_from] = params[:date_from] if (params[:date_from] && (!params[:date_from].empty?))        
    @filters_params[:date_to] = params[:date_to] if (params[:date_to] && (!params[:date_to].empty?))
    @filters_params[:domain] = params[:domain] || ""
    @filters_params[:service_type_ids] = params["service_type_ids"] if (params["service_type_ids"] && !(params["service_type_ids"].empty?))
    @filters_params[:wo_status_id] = params[:wo_status_id] if (params[:wo_status_id] && !(params[:wo_status_id].empty?))

#   @filters_params = {:date_from => date_from,:date_to =>date_to,:domain => domain,:service_type_id => service_type_id ,:user => current_user,:wo_status_id => wo_status_id}
        
    @filters = @filters_params.clone()

    @filters_params[:user] = current_user
        
    @workorders = Workorder.find_by_params(@filters_params)
    
    @price_data = Workorder.build_graph_data(Workorder.group_by_service_type(@filters_params))
    amt = Workorder.group_by_service_type(@filters_params,false)
    @amt_data = Workorder.build_graph_data(amt)
    
    @work_orders = @workorders.order(order_by).paginate(:page =>page,:per_page =>per_page)
    
    @count= @workorders.count()
    @workorder_amount= @workorders.sum("price * amount")
    @services_amount =0 
    amt.each{|key,value| @services_amount += value}
      

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
    cso_ids = params["cso_ids"] || []
    company_id =  current_user.company ? current_user.company.id : params[:company_id]
    respond_to do |format|
      Workorder.transaction do
        if @work_order.update_attributes(params[:workorder])
          flash[:notice] = 'Orden de Trabajo actualizada'
          
          CarServiceOffer.update_with_services(@work_order.services,cso_ids)
          if @work_order.finish?
            #@work_order.generate_events
            if (car.kmAverageMonthly && (car.kmAverageMonthly > 0))
              @work_order.regenerate_events  
            end
            
            send_notification @work_order.id          
          end
          format.html { redirect_to(@work_order.car)}
          format.xml  { head :ok }
        else
          @car_service_offers = @work_order.find_car_service_offer(company_id)
          @service_types = current_user.service_types
  
          format.html { render :action => "edit" }
          format.xml  { render :xml => @work_order.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def edit
    @work_order= Workorder.find(params[:id])
    @service_types = current_user.service_types
    @car_service_offers = @work_order.car_service_offers
    @company = @work_order.company
    if ((@car_service_offers.size == 0) && (@company))
      @car_service_offers = @work_order.find_car_service_offer(@company.id)
    end
    
  end

  def create
    company_id =  current_user.company ? current_user.company.id : params[:company_id]
    cso_ids = params["cso_ids"] || []
    @work_order = Workorder.new(params[:workorder])
    #@work_order.company = current_user.current_company
    @work_order.km = Car.find(@work_order.car.id).km
    @work_order.user = current_user
    saveAction =false
    Workorder.transaction do
      car = @work_order.car
      car.company = current_user.current_company
      car.save
      CarServiceOffer.update_with_services(@work_order.services,cso_ids)
      saveAction = @work_order.save
      if @work_order.finish?
        #@work_order.generate_events
        if (car.kmAverageMonthly && (car.kmAverageMonthly > 0))
          @work_order.regenerate_events  
        end
        
        send_notification @work_order.id
      end
      
    end
    
    if saveAction

      flash[:notice] = "Orden de Trabajo creada correctamente"
      redirect_to @work_order.car
    else
      @service_types = current_user.service_types
      @work_order.car = Car.find(params[:car_id]) if (params[:car_id])
      @car_service_offers = @work_order.find_car_service_offer(company_id)
      render :action => 'new'
    end
  end
  
  def new
    @company_id =  current_user.company ? current_user.company.id : params[:company_id]
    car_id = params[:car_id]
    
    @work_order = Workorder.new
    @work_order.performed = I18n.l(Time.now.to_date)
    @work_order.company_info  = params[:c] if params[:c]
    
    @work_order.company = Company.find @company_id if @company_id
    @work_order.car = Car.find(params[:car_id]) if params[:car_id]
    
    @service_types = current_user.service_types
    @car_service_offers = @work_order.find_car_service_offer(@company_id)
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
  
  def sort_column
    params[:sort] || "workorders.performed"
  end

  def sort_direction
    if params[:direction]
      %[asc desc].include?(params[:direction])? params[:direction] : "asc"
    else
      "desc"
    end
  end
  
  
end

