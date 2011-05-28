class ServiceOffersController < ApplicationController
  
  STATUS = [
      [ 'Abierto' , 'Abierto' ],
      [ 'Confirmado' , 'Confirmado' ],
      [ 'Cancelado' , 'Cancelado' ]
  ]
  
  def index
    page = params[:page] || 1
    @company_services = current_user.company.company_service.map{|s| s.service_type}
    if current_user.is_super_admin
      @offers = ServiceOffer.all.paginate(:per_page=>10,:page =>page)
    else
      @offers = current_user.company.service_offers.paginate(:per_page=>10,:page =>page)
    end
  end

  def show
    @offer = ServiceOffer.find(params[:id])
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
  end
  
  def list_offer_confirmed
    @service_confiramdos = get_offer_confirmerd
  end
  
  def get_offer_confirmerd
    ServiceOffer.all(:conditions =>["company_id = ? and status= ?",current_user.company,:Confirmado])  
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
    @cars = @offer.cars
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
  
    
  def send_notification
    ServiceOffer.send_notification
    redirect_to :action => :index
  end
 
end

