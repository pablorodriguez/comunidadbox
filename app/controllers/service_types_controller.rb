class ServiceTypesController < ApplicationController
  layout "application", :except => [:task_list,:save_material,:save_task] 
  authorize_resource
  # GET /service_types
  # GET /service_types.xml
  def index
    @service_types = ServiceType.find(:all,:order=>'name')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @service_types }
    end
  end
  
  def search_sub_category
    id = params[:id]
    @sub_categories = Category.all(:conditions =>["parent_id = ?",id])  
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
    session[:service_type] = params[:id]

    @service_type = ServiceType.find(params[:id])
    @not_in = (res = (@service_type.materials.each {|x| x.id.to_i }).uniq).length == 0 ? '' : res
    @materials = Material.find(:all, :conditions => ["id NOT IN (?)",  @not_in])

    @tasks = [] #Task.find(:all) - @service_type.tasks

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service_type }
    end
  end

  def save_material
    service_type_id=session[:service_type]
    @material = MaterialServiceType.new
    @material.service_type_id = service_type_id
    @material.material_id = params[:Materials][:parent_id]

    respond_to do |format|
      if @material.save
        @service_type = ServiceType.find(service_type_id)
        @not_in = (res = (@service_type.materials.each {|x| x.id.to_i }).uniq).length == 0 ? '' : res
        @materials = Material.find(:all, :conditions => ["id NOT IN (?)",  @not_in])

        flash[:notice] = 'Material agregado a tipo de servicio'
        format.html { redirect_to service_type_path(@service_type)}
        format.js
      else
        @service_type = ServiceType.find(service_type_id)
        format.html { render :action => :show, :id => service_type_id }
      end
    end
  end

  def destroy_material
    @material_service_type = MaterialServiceType.find(:first, :conditions => ["service_type_id = ? AND material_id = ?", session[:service_type], params[:id] ])
    @material_service_type.delete

    respond_to do |format|
      format.html { redirect_to(:action => 'show', :id => session[:service_type]) }
      format.xml  { head :ok }
    end
  end

  def save_task
    unless params[:task] == '-Seleccione una Tarea-'
      task = Task.find(params[:task])
      @service_type = ServiceType.find(params[:service_type])
      @service_type.tasks << task
      flash[:notice] = 'Tarea agregado a tipo de servicio'
      @tasks = Task.find(:all) - @service_type.tasks
      respond_to do |format|
        format.js
      end
    else
      render :nothing => true
    end
  end

  def destroy_task
    @service_type = ServiceType.find(params[:service_type])
    @service_type.tasks.delete(Task.find(params[:id]))
    @row_id="#task_#{params[:id]}"
    @tasks = Task.find(:all) - @service_type.tasks
    respond_to do |format|
      format.js { render :save_task}
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

    @service_type = ServiceType.find(params[:id])
  end

  # POST /service_types
  # POST /service_types.xml
  def create
    @service_type = ServiceType.new(params[:service_type])

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
    @service_type = ServiceType.find(params[:id])

    respond_to do |format|
      if @service_type.update_attributes(params[:service_type])
        flash[:notice] = 'ServiceType was successfully updated.'
        format.html { redirect_to(service_types_url) }
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
    @service_type = ServiceType.find(params[:id])
    items = CompanyService.find(:all, :conditions => ['service_type_id = ?', params[:id]])

    respond_to do |format|
      if items.length > 0
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

