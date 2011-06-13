class CarServiceOfferController < ApplicationController
  
  def show
    @offer = CarServiceOffer.find params[:id]
  end
  
  def index
    @offers = CarServiceOffer.where("service_offers.company_id = ? and car_service_offers.status in (?)",current_user.company.id,
    ['Aceptado']).includes(:service_offer).includes(:car)
  end
  
  def confirm
    change_status "Aceptado"
  end
  
  def reject
    change_status "Rechazado"
  end
  
  def change_status new_status 
    car_service_offer = CarServiceOffer.find params[:id]
    car_service_offer.status=new_status
    car_service_offer.save
    redirect_to service_offer_path(car_service_offer.service_offer)
  end
end
