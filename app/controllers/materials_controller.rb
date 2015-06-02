class MaterialsController < ApplicationController
  
  layout "application" ,:except =>[:details,:save_service_type]
  authorize_resource
  
  def index
    page = params[:page] || 1
    params[:company_id] = current_user.headquarter.id.to_s
    @materials = Material.find_by_params(params)    
    @service_type_ids =  params[:service_type_ids] || []    
    respond_to do |format|
      format.js {render :layout => false}    
      format.html # show.html.erb      
    end
  end

  def details
    @company_id = Company::DEFAULT_COMPANY_ID
        
    @company_id = get_company.id if company_id
    
    price_list = get_company.get_active_price_list

    params[:term] ||= ""

    @detail = params[:term] != "" ? params[:term].gsub(/\s/,"%").upcase : "NUL"
    @service_type_id = params[:service_type].to_i if params[:service_type]
    @page = params[:page] || 1
    @per_page = params[:per_page] || 10
    
    if price_list
      @materials = MaterialDetail.search(price_list.company_id,@service_type_id,@detail).paginate(:per_page=>@per_page,:page => @page)
    else
      @materials = []
    end
    
    respond_to do |format|
      format.js {render :layout => false}
      format.json { render :json => @materials.to_json(:methods => :price_fmt)}
      format.html # show.html.erb
      format.xml  { render :xml => @materials }
      
    end
  end

  def show
    @material = Material.find(params[:id])
    @not_in = (res = (@material.service_types.each {|x| x.id.to_i }).uniq).length == 0 ? '' : res
    @servicetypes = ServiceType.find(:all, :conditions => ["id NOT IN (?)",  @not_in],:order =>'name')

    respond_to do |format|
      format.html # show.html.erb      
    end
  end

  def save_service_type
    material_id=params[:id]
    @material = MaterialServiceType.new
    @material.material_id = material_id
    @material.service_type_id = params[:ServiceType][:parent_id]

    respond_to do |format|
      if @material.save
        @materials = Material.find(material_id)
        @not_in = (res = (@materials.service_types.each {|x| x.id.to_i }).uniq).length == 0 ? '' : res
        @servicetypes = ServiceType.find(:all, :conditions => ["id NOT IN (?)",  @not_in])

        flash[:notice] = 'Material agregado a tipo de servicio'
        #format.html { redirect_to :controller => :materials, :action => :show, :id => material_id  }
        format.js
      else
        @materials = Material.find(material_id)
        format.html { render :action => :show, :id => material_id }
      end
    end
  end

  def destroy_servicetype
    @material_service_type = MaterialServiceType.find(:first, :conditions => ["material_id = ? AND service_type_id = ?", session[:material_id], params[:id] ])
    @material_service_type.delete

    respond_to do |format|
      format.html { redirect_to(:action => 'show', :id => session[:material_id]) }
      format.xml  { head :ok }
    end
  end

  def new
    @material = Material.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @material }
    end
  end

  def edit
    @material = Material.find(params[:id])    
    @not_in = (res = (@material.service_types.each {|x| x.id.to_i }).uniq).length == 0 ? '' : res
    @servicetypes = ServiceType.find(:all, :conditions => ["id NOT IN (?)",  @not_in],:order =>'name')
  end

  def create
    @material = Material.new(params[:material])    
    @material.company = current_user.headquarter
    
    respond_to do |format|
      if @material.save
        format.html { redirect_to(@material) }
        format.xml  { render :xml => @material, :status => :created, :location => @material }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @material.errors, :status => :unprocessable_entity }
      end
    end
  end

   def remove
    @service_type = ServiceType.find params[:service_type_id]
    @material = Material.find params[:id]
    @material_service_type = MaterialServiceType.where("service_type_id = ? and material_id = ?",@service_type,params[:id]).first
    
    if @material_service_type.can_delete?
      @material_service_type.destroy
    else
       flash[:notice] = 'No se puede desvincular el tipo de servicio. Fue utilizado en servicios realizados'
    end
    redirect_to @material
    
  end

  def update
    @material = Material.find(params[:id])

    respond_to do |format|
      if @material.update_attributes(params[:material])        
        format.html { redirect_to(@material) }
        format.js {render :layout => false}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @material.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @material = Material.find(params[:id])
    @material.destroy_or_disable

    respond_to do |format|
      format.html { redirect_to(materials_url) }
      format.xml  { head :ok }
    end
  end

  def export    
    csv = Material.to_csv(current_user.headquarter.id)
    #encode = get_user_agent_encode
    unless csv.empty?
      respond_to do |format|        
        format.csv { send_data csv.encode("iso-8859-1"),:filename => "materiales.csv", :type => "text/csv; charset=#"iso-8859-1"; header=present"}
        format.html {redirect_to materials_path}
      end
    else
      flash[:alert] = t("Error")
      redirect_to materials_path
    end
  end

  def import
    if params[:file].present?
      @result = Material.from_csv params[:file], current_user.headquarter.id,params[:service_type_ids]      
    else
      flash[:alert] = t("import_file_error")
    end
    redirect_to materials_path
    
  end
end

