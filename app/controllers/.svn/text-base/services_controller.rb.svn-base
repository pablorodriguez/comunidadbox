class ServicesController < ApplicationController

  layout nil

  def show
    @service = Service.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service }
    end
  end

  def companies_services
    @servicios = ServiceType.find(:all)
  end

  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service }
    end
  end
  
  def remove_material
    @material_id = params[:id]
    @service = session[:service]
    @service.remove_material(@material_id.to_i)

    respond_to do |format|
      format.html
      format.js
    end
  end
  
  
  def add_material
    @service = session[:service]
    material_d_p = MaterialDetail.new(params[:material])
    if material_d_p.service_type_id == nil
      material_d_p.service_type_id =@service.service_type.id
    end
    material_d = MaterialDetail.all(:conditions=>["detail = ? and company_id = ? and service_type_id = ?",material_d_p.detail,current_user.company.id,material_d_p.service_type_id])[0]
    
    mst = MaterialServiceType.find_by_material_id_and_service_type_id(material_d.material_id,material_d.service_type_id)
    @material_service = MaterialService.new
    @material_service.row = material_d_p.row unless material_d_p.row==""
    
    @material_service.material_service_type=mst
    @material_service.amount = material_d_p.amount.to_i
    @material_service.price = material_d_p.price.to_f
    #@material_service.detail = material_d_p.detail

    @service.work_order =session[:work_order]
    service_type_id = @service.service_type.id if @service.service_type != nil
    service_type_id = material_d_p.service_type_id if service_type_id == nil
    service_type = ServiceType.find(service_type_id)
    @tasks = service_type.tasks
    @service.add_material(@material_service)
    @service.task_ids = material_d_p.task_ids
    @service.comment = material_d_p.comment
    @service.service_type = service_type unless service_type == nil
    
    respond_to do |format|
      format.html { redirect_to(services_url) }
      format.js
    end
  end
  
  def add_service
    @workOrder = session[:work_order]
    @service = session[:service]
    @workOrder.add_service @service
    session[:service]= Service.new
  end
  
  def edit
    id= params[:id]
    @workOrder = session[:work_order]
    @service = @workOrder.get_service id.to_i
    @materials = @service.material_services
    session[:service] =@service
  end
  
  def remove_service
    @id= params[:id]
    @workOrder = session[:work_order]
    @workOrder.remove_service @id.to_i
  end

  # POST /services
  # POST /services.xml
  def create
    @service = Service.new(params[:service])

    respond_to do |format|
      if @service.save
        flash[:notice] = 'Service was successfully created.'
        format.html { redirect_to(@service) }
        format.xml  { render :xml => @service, :status => :created, :location => @service }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /services/1
  # PUT /services/1.xml
  def update
    @service = Service.find(params[:id])

    respond_to do |format|
      if @service.update_attributes(params[:service])
        flash[:notice] = 'Service was successfully updated.'
        format.html { redirect_to(@service) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /services/1
  # DELETE /services/1.xml
  def destroy
    @service = Service.find(params[:id])
    @service.destroy

    respond_to do |format|
      format.html { redirect_to(services_url) }
      format.xml  { head :ok }
    end
  end
end
