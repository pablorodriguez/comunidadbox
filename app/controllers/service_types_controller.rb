class ServiceTypesController < ApplicationController
  #layout "application", :except => [:task_list,:save_material,:add_task,:remove_task] 
  #authorize_resource
  # GET /service_types
  # GET /service_types.xml
  def index
    @service_types = ServiceType.unscoped.where("company_id IN (?) ",  company_id).order('name')
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @service_types }
    end
  end
  
  def search_sub_category
    id = params[:id]
    @sub_categories = Category.all(:conditions =>["parent_id = ?",id])  
  end
  

  def search_material
    @service_type = ServiceType.find(params[:id])
    params[:service_type_ids] = params[:id]
    page = params[:page] || 1    
    @materials = Material.find_by_params params    
    respond_to do |format|
      format.js {render :layout => false}
    end
  end

  def task_list    
    service_type = ServiceType.find(params[:id])
    @service = session[:service]
    @categories = Category.all(:order =>:name)
    @tasks = service_type.tasks
  end

  # GET /service_types/1
  # GET /service_types/1.xml
  def show    
    @service_type = ServiceType.unscoped.find(params[:id])
    params[:service_type_ids] = params[:id]
    page = params[:page] || 1    
    @materials = Material.find_by_params params   
    @tasks = Task.find(:all) - @service_type.tasks

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service_type }
    end
  end

  def add_material
    @service_type = ServiceType.find params[:id]
    @material = Material.find params[:material_id]
    @material_service_type = MaterialServiceType.new
    @material_service_type.service_type = @service_type
    @material_service_type.material = @material
   
    respond_to do |format|
      if @material_service_type.save        
        format.js { render :file => "service_types/add_material",:layout => false}
      else
        format.html :nothing => true
      end
    end
  end

  def remove
    @service_type = ServiceType.find params[:id]
    @material_service_type = MaterialServiceType.where("service_type_id = ? and material_id = ?",params[:id],params[:material_id]).first
    params[:service_type_ids] = params[:id]
    @materials = Material.find_by_params params   
    @tasks = Task.find(:all) - @service_type.tasks
    
    if @material_service_type.can_delete?
      @material_service_type.destroy
    else
       flash[:notice] = 'No se puede borrar el material. Fue utilizado en servicios realizados'
    end
    redirect_to @service_type
    
  end

  def destroy_material
    @material_service_type = MaterialServiceType.find(:first, :conditions => ["service_type_id = ? AND material_id = ?", session[:service_type], params[:id] ])
    @material_service_type.delete

    respond_to do |format|
      format.html { redirect_to(:action => 'show', :id => session[:service_type]) }
      format.xml  { head :ok }
    end
  end

  def add_task
    if params[:service_type][:tasks]
      task = Task.find(params[:service_type][:tasks])
      @service_type = ServiceType.find(params[:id])
      @service_type.tasks << task      
      @tasks = Task.find(:all) - @service_type.tasks

      respond_to do |format|
        format.js {render :layout => false}
      end
    else
      render :nothing => true
    end
  end

  def remove_task
    @service_type = ServiceType.find(params[:id])
    @service_type.tasks.delete(Task.find(params[:t]))
    @row_id="#task_#{params[:id]}"
    @tasks = Task.find(:all) - @service_type.tasks
    respond_to do |format|
      format.js { render :file => "service_types/add_task",:layout => false}
    end
  end

  # GET /service_types/new
  # GET /service_types/new.xml
  def new
    @service_type = ServiceType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service_type }
    end
  end

  # GET /service_types/1/edit
  def edit
    #@service_type_all = ServiceType.find(:all)
    #@selected_service_type = @service_type_all[2]

    @service_type = ServiceType.unscoped.find(params[:id])
  end

  # POST /service_types
  # POST /service_types.xml
  def create
    @service_type = ServiceType.new(params[:service_type])
    @service_type.company_id = current_user.company_active.id
    respond_to do |format|
      if @service_type.save
        flash[:notice] = 'El Tipo de Servicio se creo con exito.'
        format.html { redirect_to(service_types_url) }
        format.xml  { render :xml => @service_type, :status => :created, :location => @service_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /service_types/1
  # PUT /service_types/1.xml
  def update
    @service_type = ServiceType.unscoped.find(params[:id])
    respond_to do |format|
      if @service_type.update_attributes(params[:service_type])      
        format.html { redirect_to(@service_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /service_types/1
  # DELETE /service_types/1.xml
  def destroy
    @service_type = ServiceType.unscoped.find(params[:id])
    can_destroy = @service_type.is_used current_user
    
    respond_to do |format|
      unless can_destroy
        flash[:notice] = 'No se pudo eliminar el tipo de servicio, existen servicios asociados a el'
        format.html { redirect_to(service_types_url) }
        format.xml  { render :xml => @service_type, :status => :deleted, :location => @service_type }
      else
        flash[:notice] = 'El tipo de servicio fue eliminado con exito'
        @service_type.destroy
        format.html { redirect_to(service_types_url) }
        format.xml  { head :ok }
      end
    end
  end

end

