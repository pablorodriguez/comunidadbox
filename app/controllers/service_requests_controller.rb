class ServiceRequestsController < ApplicationController
  # GET /service_requests
  # GET /service_requests.json
  def index
    
    @service_requests = ServiceRequest.for_user current_user

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @service_requests }
    end
  end

  # GET /service_requests/1
  # GET /service_requests/1.json
  def show
    @service_request = ServiceRequest.find(params[:id])

    if company_id
      @offer = ServiceOffer.new(:company_id => get_company_id)
      @offer.build_offer_service_types @service_request.service_types      
      @offer.car_service_offers << CarServiceOffer.new(:car => @service_request.car)
    end
    respond_to do |format|
      format.html # show.html.erb      
      format.json {render :layout => false}
    end
  end

  # GET /service_requests/new
  # GET /service_requests/new.json
  def new
    @service_request = ServiceRequest.new
    @service_request.car = current_user.cars.first if current_user.cars.size == 1

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @service_request }
    end
  end

  # GET /service_requests/1/edit
  def edit
    @service_request = ServiceRequest.find(params[:id])
    authorize! :update, @service_request
  end

  # POST /service_requests
  # POST /service_requests.json
  def create
    @service_request = ServiceRequest.new(params[:service_request])
    @service_request.user = current_user

    respond_to do |format|
      if @service_request.save
        format.html { redirect_to @service_request}
        format.json { render json: @service_request, status: :created, location: @service_request }
      else
        format.html { render action: "new" }
        format.json { render json: @service_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /service_requests/1
  # PUT /service_requests/1.json
  def update
    @service_request = ServiceRequest.find(params[:id])
    authorize! :update, @service_request
    respond_to do |format|
      if @service_request.update_attributes(params[:service_request])
        format.html { redirect_to @service_request}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @service_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_requests/1
  # DELETE /service_requests/1.json
  def destroy
    @service_request = ServiceRequest.find(params[:id])
    authorize! :destroy, @service_request
    @service_request.destroy

    respond_to do |format|
      format.html { redirect_to service_requests_url }
      format.json { head :no_content }
    end
  end
end
