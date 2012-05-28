class CompaniesController < ApplicationController
  layout "application", :except => [:add_service_type,:remove_service_type,:search]
  skip_before_filter :authenticate_user!, :only => [:index,:show,:all,:search,:search_distance]
  authorize_resource
  
  def service_types    
    @company = get_company
    @not_in = @company.service_type.map(&:id)
    if @not_in.size >0
      @service_types =ServiceType.where("id NOT IN (?) ",  @not_in).order('name')
    else
      @service_types =ServiceType.order('name').all
    end
    @company_service_type = @company.service_type

    @all_service_types = ServiceType.order('name').all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def search
    @companies = Company.search params
    respond_to do |format|
      format.js
    end
  end

  def search_distance

    @distance = (params[:distance] && !(params[:distance].blank? ))  ? params[:distance] : "10"    
    @street = (params[:street] && !(params[:street].blank?)) ? params[:street] : ""

    if @street.blank? && (current_user && current_user.addresssize > 0)
      @street = current_user.address.to_text 
    else
      flash[:error] ="Debe ingresar una direccion"
    end
    
    if (@street  != "")
      distance_in_milles = @distance.to_i * 0.621371192
      logger.debug "### distance_in_milles #{distance_in_milles}, @distance #{@distance} Params #{params[:distance] }"


      @address = Address.companies.near(@street, distance_in_milles, :order => :distance)
      logger.debug "### distance , #{distance_in_milles} street #{@street} , found #{@address.size}"

      @json = @address.to_gmaps4rails do |address, marker|
        @distance_km = (address.distance.to_f * 1.609344).round(2).to_s + ' Km'

        marker.infowindow render_to_string(:partial => "/companies/info_window", :locals => { :address => address}).gsub(/\n/, '').gsub(/"/, '\"')
      end

      #lat = Geocoder.coordinates(@street)[0]
      #lng = Geocoder.coordinates(@street)[1]
      #distance = @distance.to_f * 1000
      #@circles_json = '[{"lng": ' + lng.to_s + ', "lat": ' + lat.to_s + ', "radius": ' + distance.to_s + ', "strokeWeight" : 3, fillColor: "#FF0000", fillOpacity: 0.2 }]'
      render :action => 'all'
    else        
      redirect_to all_companies_path
    end

  end

  def all
    @companies = Company.best
    @car_id = params[:car_id]
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @companies }
    end
  end

  def index
    @companies = current_user.companies

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @companies }
    end
  end

  # GET /companies/1
  # GET /companies/1.xml
  def show
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/new
  # GET /companies/new.xml
  def new
    @company = Company.new
    @company.user = current_user
    @company.build_address if @company.address.nil?
    respond_to do |format|
      format.js { render :layout => false}
      format.html # new.html.erb
      format.xml  { render :xml => @company }
    end
  end

  def activate
    id = params[:id]
    Company.transaction do
      current_user.companies.each do |c|
        c.active=false
        c.save
      end
      comp = Company.find id
      comp.active = true
      comp.save
    end
    redirect_to companies_path
  end

  # GET /companies/1/edit
  def edit
    @company = Company.find(params[:id])
    @user = current_user
  end

  # POST /companies
  # POST /companies.xml
  def create
    @company = Company.new(params[:company])

    respond_to do |format|
      if @company.save
        flash[:notice] = 'La empresa se creo satisfactoriamente.'
        user_role = UserRole.new
        user_role.role = Role.administrator
        user_role.company =  @company
        current_user.user_roles << user_role
        current_user.save
        PriceList.copy_default @company.id
        format.html { redirect_to(@company) }
        format.xml  { render :xml => @company, :status => :created, :location => @company }
        format.js { render :action => "show" }
      else
        format.html { render :action => "new" }
        format.js { render :action => "new" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.xml
  def update
    @company = Company.find(params[:id])

    respond_to do |format|
      if @company.update_attributes(params[:company])
        flash[:notice] = 'La empresa se actualizo correctamente'
        format.html { redirect_to(@company) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.xml
  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to(companies_url) }
      format.xml  { head :ok }
    end
  end

  def add_service_type
    company = get_company
    companyService = company.company_service.build
    @service_error = false
    service_type = ServiceType.find(params[:id])
    @service_type_id =service_type.id
    companyService.service_type = service_type
    companyService.save
    @msg ="Tipo de Servicio asociado exitosamente"
    respond_to do |format|
        format.js {render :msg}
    end
  end


  def remove_service_type
    @service_type_id = params[:id].to_i
    company_id= get_company.id
    company_service = CompanyService.where("company_id = ? and service_type_id = ?",company_id,@service_type_id)
    @msg ="Tipo de Servicio eliminado exitosamente"
    @service_error = false
    if company_service != nil
      company_service[0].delete
    end
    respond_to do |format|
        format.js {render :msg}
    end
  end



end
