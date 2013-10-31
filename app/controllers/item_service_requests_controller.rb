class ItemServiceRequestsController < ApplicationController
  # GET /item_service_requests
  # GET /item_service_requests.json
  def index
    @item_service_requests = ItemServiceRequest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @item_service_requests }
    end
  end

  # GET /item_service_requests/1
  # GET /item_service_requests/1.json
  def show
    @item_service_request = ItemServiceRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item_service_request }
    end
  end

  # GET /item_service_requests/new
  # GET /item_service_requests/new.json
  def new
    @item_service_request = ItemServiceRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item_service_request }
    end
  end

  # GET /item_service_requests/1/edit
  def edit
    @item_service_request = ItemServiceRequest.find(params[:id])
  end

  # POST /item_service_requests
  # POST /item_service_requests.json
  def create
    @item_service_request = ItemServiceRequest.new(params[:item_service_request])

    respond_to do |format|
      if @item_service_request.save
        format.html { redirect_to @item_service_request, notice: 'Item service request was successfully created.' }
        format.json { render json: @item_service_request, status: :created, location: @item_service_request }
      else
        format.html { render action: "new" }
        format.json { render json: @item_service_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /item_service_requests/1
  # PUT /item_service_requests/1.json
  def update
    @item_service_request = ItemServiceRequest.find(params[:id])

    respond_to do |format|
      if @item_service_request.update_attributes(params[:item_service_request])
        format.html { redirect_to @item_service_request, notice: 'Item service request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item_service_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_service_requests/1
  # DELETE /item_service_requests/1.json
  def destroy
    @item_service_request = ItemServiceRequest.find(params[:id])
    @item_service_request.destroy

    respond_to do |format|
      format.html { redirect_to item_service_requests_url }
      format.json { head :no_content }
    end
  end
end
