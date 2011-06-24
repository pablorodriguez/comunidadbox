class CarServiceOffersController < ApplicationController
  
  def show
    @car_service_offer = CarServiceOffer.find params[:id]
    @cars = [] 
    @cars << @car_service_offer
  end
  
  def index    
    @offers = CarServiceOffer.where("car_id IN (?) and car_service_offers.status IN (?)",current_user.cars(&:id),
      [Status::CONFIRMED, Status::PERFORMED, Status::SENT]).includes(:service_offer).includes(:car)
  end
  
  def confirm
    change_status Status::CONFIRMED
  end
  
  def reject
    change_status Status::REJECTED
  end
  
  def change_status new_status 
    car_service_offer = CarServiceOffer.find params[:id]
    car_service_offer.status=new_status
    car_service_offer.save
    redirect_to service_offer_path(car_service_offer.service_offer)
  end
end
