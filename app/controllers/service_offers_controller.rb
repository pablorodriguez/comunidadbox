class ServiceOffersController < ApplicationController
  
  STATUS = [
      [ 'Abierto' , 'Abierto' ],
      [ 'Confirmado' , 'Confirmado' ],
      [ 'Cancelado' , 'Cancelado' ]
  ]
  
  def index
    page = params[:page] || 1
    @service_types = current_user.service_types
    params[:from]
    from = (params[:service_offer_since] && (!params[:service_offer_since].empty?)) ? params[:service_offer_since] : ""
    until_d = (params[:service_offer_until] && (!params[:service_offer_until].empty?)) ? params[:service_offer_until] : ""
    service_type_id = (params[:service_type_id] && (!params[:service_type_id].empty?)) ? params[:service_type_id] : ""
    title = (params[:title] && (!params[:title].empty?)) ? params[:title] : ""   
    filters ={:form => from,:until=>until_d,:service_type_id=>service_type_id,:status=>params[:status],:title =>title}
    
    @offers = current_user.find_service_offers(filters)
    @offers = @offers.paginate(:per_page=>10,:page =>page)
        
    respond_to do |format|
      format.html
      format.js { render :layout => false}
    end
  end

  def show
    @offer = ServiceOffer.find(params[:id])
    if current_user.is_administrator
      @cars = @offer.car_service_offer
    end
    
    unless current_user.company
      @cars = @offer.my_cars current_user
    end
  end

  def new
    @title ="Nueva Oferta de Servicio"
    @offer = ServiceOffer.new(params[:service_offer])
    if params[:checked_ids].nil?
      flash[:error] = 'Debe elegir al menos un automovil'
      redirect_to :back
    else
      @offer.car_service_offer = Set.new
      params[:checked_ids].each do |car_id|
        car_service_offer = CarServiceOffer.new
        car_service_offer.car = Car.find(car_id)
        car_service_offer.service_offer = @offer
        @offer.car_service_offer << car_service_offer
      end
    end
    @cars = @offer.car_service_offer
  end
  
  def list_offer_confirmed
    @service_confiramdos = get_offer_confirmerd
  end
  
  def get_offer_confirmerd
    ServiceOffer.where(["company_id = ? and status= ?",current_user.company,:Confirmado])  
  end
  
  def send_service_offers    
    @service_confiramdos = get_offer_confirmerd
    @service_confirmados.each do |s|
      s.status ="Enviado"
      s.send_at = Time.now
      s.save
    end
  end

  def create
    @offer = ServiceOffer.new(params[:service_offer])
    @offer.company = current_user.company
    params[:car_ids].each do |car_id|
      car_service_offer = CarServiceOffer.new
      car_service_offer.status = @offer.status
      car_service_offer.car = Car.find(car_id.to_i)
      car_service_offer.service_offer = @offer
      @offer.car_service_offer << car_service_offer      
    end

    if @offer.save
      flash[:notice] = 'Se ha creado la oferta!'
      redirect_to service_offers_path
    else
      render :action => "new"
    end
  end

  def edit
    @title ="Editar Oferta de Servicio"
    @offer = ServiceOffer.find(params[:id])
    @cars = @offer.car_service_offer
  end

  def update
    @offer = ServiceOffer.find(params[:id])
    if @offer.update_attributes(params[:service_offer])
      flash[:notice] = 'Se ha actualizado la oferta!'
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
    Resque.enqueue ServiceOfferJob
    logger.info "### envio de notificacion service offer"
    redirect_to :action => :index
  end
  
  def notify_email
    users = ServiceOffer.get_service_offer_by_user
    @car = users.keys[0]
    @user = @car.user
    @service_offers = users[@car]
    respond_to do |format|
      format.html { render :file=>"service_offer_mailer/notify",:layout => "emails" }
    end
  end
 
end

