class MaterialRequestsController < ApplicationController

 def new
    @material_request = MaterialRequest.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @material_request }
  	end
  end

  def index  
    @material_requests = current_user.search_material_request
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @material_requests }
    end  
  end

 def create
    @material_request = MaterialRequest.new(params[:material_request])
    @material_request.user_id = current_user.id
    @material_request.company_id = current_user.company.id
    respond_to do |format|
      if @material_request.save
        flash[:notice] = 'La solicitud del material ah sido creada.'
        format.html { redirect_to(@material_request) }
        format.xml  { render :xml => @material_request, :status => :created, :location => @material_request }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @material_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @material_request = MaterialRequest.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @material_request }
    end
  end

   def edit
    @material_request = MaterialRequest.find(params[:id])
  end

  def update
    @material_request = MaterialRequest.find(params[:id])
     respond_to do |format|
      if !current_user.is_super_admin?
        if @material_request.update_attributes(params[:material_request]) 
           format.html { redirect_to(material_request_path) }
           format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @material_request.errors, :status => :unprocessable_entity }
        end
      end 
      if @material_request.is_rejected? && current_user.is_super_admin?
        if @material_request.update_attributes(params[:material_request]) 
            format.html { redirect_to :action => "destroy" }
            format.xml  { head :ok }
          else
            format.html { render :action => "edit" }
            format.xml  { render :xml => @material_request.errors, :status => :unprocessable_entity }
          end
      end
      if @material_request.is_approved? && current_user.is_super_admin?
        if @material_request.update_attributes(params[:material_request]) 
            format.html { redirect_to :action => "approved" }
            format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @material_request.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @material_request = MaterialRequest.find(params[:id])
    if user_signed_in? && current_user.is_super_admin?
      @material_request.update_attribute(:state, Status::REJECTED) 
      respond_to do |format|
       flash[:notice] = 'La solicitud del material ah sido Rechazada.'
        format.html { render :action => "edit" }
        format.xml  { head :ok }
      end   
    else
      @material_request.destroy
      respond_to do |format|
        format.html { redirect_to(material_requests_url) }
        format.xml  { head :ok }
      end
    end
  end

  def approved
    @material_request = MaterialRequest.find params[:id]
    @code = @material_request.code
    @material = Material.create(:code => @code,:prov_code => @code, :provider => @material_request.provider, :name => @material_request.description)
    @material_service_type = MaterialServiceType.create(:service_type_id => @material_request.service_type_id, :material_id => @material.id)
    @material_request.material = @material.id
    respond_to do |format|
    if @material_service_type.save
       @material_request.update_attribute(:state, Status::APPROVED)
        flash[:notice] = 'La solicitud del material ah sido aprobada.'
        format.html {  redirect_to :action => "edit" }
        format.xml  { render :xml => @material_request, :status => :created, :location => @material_request }
      else
        flash[:notice] = 'No se pudo salvar'
        format.html { render :action => "new" }
        format.xml  { render :xml => @material_request.errors, :status => :unprocessable_entity }
    end
  end
 end

 def search
    state = params[:state] || ""
    created_at = params[:created_at] || ""
    @material_requests = MaterialRequest.where("state like ? AND created_at like ?",
      "%#{state}%","%#{created_at}%")
    respond_to do |format|
      format.js { render :layout => false}
    end
   end
end

