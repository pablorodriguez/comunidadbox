class MaterialRequestsController < ApplicationController

 def new
    @material_request = MaterialRequest.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @material_request }
  	end
  end

  def index  
    status = params[:status] || ""
    detail = params[:detail] || ""    
    @material_requests = current_user.search_material_request(status,detail)
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
      if @material_request.update_attributes(params[:material_request]) 
         format.html { redirect_to(material_request_path) }
         format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @material_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @material_request = MaterialRequest.find(params[:id])
    @material_request.destroy
    respond_to do |format|
      format.html { redirect_to(material_requests_url) }
      format.xml  { head :ok }
    end
  end


end

