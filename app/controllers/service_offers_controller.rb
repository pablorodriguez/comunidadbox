# encoding: utf-8
class ServiceOffersController < ApplicationController
  skip_before_filter :authenticate_user!,:only =>:show_ad
  authorize_resource

  def index
    page = params[:page] || 1
    @service_types = current_user.service_types
    from = (params[:service_offer_since] && (!params[:service_offer_since].empty?)) ? params[:service_offer_since] : ""
    until_d = (params[:service_offer_until] && (!params[:service_offer_until].empty?)) ? params[:service_offer_until] : ""
    service_type_id = (params[:service_type_id] && (!params[:service_type_id].empty?)) ? params[:service_type_id] : ""
    title = (params[:title] && (!params[:title].empty?)) ? params[:title] : ""
    filters ={:form => from,:until=>until_d,:service_type_id=>service_type_id,:status=>params[:status],:title =>title}

    @offers = current_user.find_service_offers(filters,company_id).paginate(:per_page=>10,:page =>page)

    respond_to do |format|
      format.html
    end
  end

  def show_ad
    @service_offer = ServiceOffer.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf {
          prawnto :prawn => {
            :page_size => 'A4',
            :left_margin => 20,
            :right_margin => 20,
            :top_margin => 15,
            :bottom_margin => 15},
            :filename=>"advertisement_#{@service_offer.id}.pdf"

        render :layout => false
        }
    end
  end

  def show
    @service_offer = ServiceOffer.find(params[:id])
    if current_user.is_administrator?
      @vehicles = @service_offer.vehicle_service_offers
    end
    @vehicles = @service_offer.vehicle_service_offers

  end

  def new
    @offer = ServiceOffer.new
    #@offer.offer_service_types.build :service_type_id => current_user.service_types.first.id

    #@offer.advertisement.advertisement_days.build(:published_on => 2.days.since.to_date)
    #@offer.advertisement.advertisement_days.build(:published_on => 3.days.since.to_date)
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @advertisements_by_date = Advertisement.search_by_date @date
    @vehicles = []
  end


  def new_s
    @title ="Oferta de Servicio"
    @offer = ServiceOffer.new()
    @offer.offer_service_types.build(:service_type_id => params[:service_type_id])

    @events_ids = params[:events_ids_chk] || []
    @events_ids.slice!(0) if @events_ids
    @events_ids = @events_ids.split("#")

    if params[:checked_ids].nil?
      flash[:error] = 'Debe elegir al menos un automovil'
      redirect_to :back
    else
      @offer.vehicle_service_offers = []
      @events_ids.each do |vehicle_id|
        vehicle_service_offer = VehicleServiceOffer.new
        vehicle_service_offer.vehicle = Vehicle.find(vehicle_id)
        vehicle_service_offer.service_offer = @offer
        @offer.vehicle_service_offers << vehicle_service_offer
      end
    end
    @vehicles = @offer.vehicle_service_offers
  end

  def list_offer_confirmed
    @service_confiramdos = get_offer_confirmerd
  end

  def get_offer_confirmerd
    ServiceOffer.where("company_id = ? and status= ?",get_company.id,:Confirmado)
  end

  def confirm
    redorect_to :index
  end

  def create
    @offer = ServiceOffer.new(params[:service_offer])
    @offer.company = get_company
    @vehicle_ids = params[:vehicle_ids] || []
    @vehicle_ids.each do |vehicle_id|
      vehicle_service_offer = VehicleServiceOffer.new
      vehicle_service_offer.status = Status::OPEN
      if @offer.is_confirmed?
        vehicle_service_offer.status = Status::CONFIRMED
      end

      vehicle_service_offer.vehicle = Vehicle.find(vehicle_id.to_i)
      vehicle_service_offer.service_offer = @offer
      @offer.vehicle_service_offers << vehicle_service_offer
    end

    @vehicles = @offer.vehicle_service_offers

    if @offer.save
      respond_to do |format|
        format.html { redirect_to service_offers_path}
        format.js {render :layout => false}
      end
    else
      respond_to do |format|
        format.html {render :action => "new_s"}
        format.js {render :layout => false}
      end
    end
  end

  def edit
    @offer = ServiceOffer.find(params[:id])

    @vehicles = @offer.vehicle_service_offers
    if @offer.status != Status::OPEN
      flash[:notice]="No se puede editar la oferta de servicio ID: #{@offer.id} Status: #{Status.status(@offer.status)}"
      redirect_to service_offers_path
    end
  end

  def update
    @offer = ServiceOffer.find(params[:id])
    if @offer.update_attributes(params[:service_offer])
      redirect_to service_offers_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @offer = ServiceOffer.find(params[:id])
    @offer.destroy
    redirect_to service_offers_path
  end

  def notify
    #Resque.enqueue ServiceOfferJob
    ServiceOffer.notify
    logger.info "### envio de notificacion service offer"
    redirect_to :action => :index
  end

  def notify_email
    users = ServiceOffer.get_service_offer_by_user
    if users.size > 0
      @vehicle = users.keys[1]
      @user = @vehicle.user
      @service_offers = users[@vehicle]
      respond_to do |format|
        format.html { render :file=>"service_offer_mailer/notify",:layout => "emails" }
      end

    end
  end



end

