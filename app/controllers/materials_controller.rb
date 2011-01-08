class MaterialsController < ApplicationController
  layout "application" ,:except =>[:details,:save_service_type]
  def index
    page = params[:page] || 1
    if params[:codigo] || params[:nombre]
      @condition_select = ''
      unless params[:codigo].empty?
        unless @condition_select == ''
          @condition_select += " AND "
        end
        @condition_select += "code LIKE '%" + params[:codigo].upcase + "%'"
        @codigo = params[:codigo]
      else
        @codigo = nil
      end
      unless params[:nombre].empty?
        unless @condition_select == ''
          @condition_select += " AND "
        end
        @condition_select += 'name LIKE ' + "'%" + params[:nombre].to_s.upcase + "%'"
        @nombre = params[:nombre]
      else
        @nombre = nil
      end
      unless @condition_select == ''
        page = params[:page] || 1
        @materials = Material.paginate(:all, :per_page => 20, :page => page, :order=>'name', :conditions => @condition_select)
      else
        page = params[:page] || 1
        @materials = Material.paginate(:all, :per_page => 20, :page => page, :order=>'name')
      end
    else
      @materials = Material.paginate(:all, :per_page => 20, :page => page, :order=>'name')
    end
  end

  def details
    company_id = Company::DEFAULT_COMPANY_ID
    if current_user.company
      company_id = current_user.company_id
    end
    material = MaterialDetail.new(params[:material])
    search = material.detail
    service_type_id = material.service_type_id
    search = search.gsub(/\s/,"%").upcase
    service_type_id = service_type_id.to_i
    page = params[:page] || 1
    per_page = material.per_page.blank? ? 10 :material.per_page
    @materials = MaterialDetail.paginate(:all,:per_page=>per_page,:page => page,:conditions=>['detail_upper LIKE ? and service_type_id = ? and company_id = ?',"%#{search}%",service_type_id,company_id])

    respond_to do |format|
      format.js
      format.html # show.html.erb
      format.xml  { render :xml => @materials }
      
    end
  end

  def show
    session[:material_id] = params[:id]

    @materials = Material.find(params[:id])
    @not_in = (res = (@materials.service_types.each {|x| x.id.to_i }).uniq).length == 0 ? '' : res
    @servicetypes = ServiceType.find(:all, :conditions => ["id NOT IN (?)",  @not_in])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @materials }
    end
  end

  def save_service_type
    material_id=session[:material_id]
    @material = MaterialServiceType.new
    @material.material_id = material_id
    @material.service_type_id = params[:ServiceType][:parent_id]

    respond_to do |format|
      if @material.save
        @materials = Material.find(material_id)
        @not_in = (res = (@materials.service_types.each {|x| x.id.to_i }).uniq).length == 0 ? '' : res
        @servicetypes = ServiceType.find(:all, :conditions => ["id NOT IN (?)",  @not_in])

        flash[:notice] = 'Material agregado a tipo de servicio'
        format.html { redirect_to :controller => :materials, :action => :show, :id => material_id  }
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
  end

  def create
    @material = Material.new(params[:material])
    @material.prov_code = @material.code if @material.prov_code.nil?

    respond_to do |format|
      if @material.save
        flash[:notice] = 'Material creado exitosamente.'
        format.html { redirect_to(@material) }
        format.xml  { render :xml => @material, :status => :created, :location => @material }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @material.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @material = Material.find(params[:id])

    respond_to do |format|
      if @material.update_attributes(params[:material])
        flash[:notice] = 'Material actualizado exitosamente.'
        format.html { redirect_to(@material) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @material.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @material = Material.find(params[:id])
    @material.destroy

    respond_to do |format|
      format.html { redirect_to(materials_url) }
      format.xml  { head :ok }
    end
  end
end

