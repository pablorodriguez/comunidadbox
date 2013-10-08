class CarServiceOffersController < ApplicationController
  
  def show
    @car_service_offer = CarServiceOffer.find params[:id]
    @cars = [] 
    @cars << @car_service_offer
  end
  
  def index    
    @car_service_offers = CarServiceOffer.where("car_id IN (?) and car_service_offers.status IN (?)",current_user.cars(&:id),
      [Status::CONFIRMED, Status::PERFORMED, Status::SENT]).includes(:service_offer).includes(:car)
  end
  
  def confirm
    car_service_offer = CarServiceOffer.find params[:id]
    debugger
    car_service_offer.update_attribute(:status, Status::CONFIRMED)    
    redirect_to car_service_offer
  end
  
  def reject
    car_service_offer = CarServiceOffer.find params[:id]
    car_service_offer.update_attribute(:status, Status::REJECTED)    
    redirect_to car_service_offer
  end
  
  def change_status new_status 
    
  end
end
