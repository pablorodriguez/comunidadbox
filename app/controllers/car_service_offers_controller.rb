class CarServiceOffersController < ApplicationController
  
  def show
    @car_service_offer = CarServiceOffer.find params[:id]    
    authorize! :read, @car_service_offer    
  end
  
  def index    
    @car_service_offers = CarServiceOffer.search_by_cars_ids(current_user.cars_ids)  
  end
  
  def confirm
    car_service_offer = CarServiceOffer.find params[:id]    
    car_service_offer.update_attribute(:status, Status::CONFIRMED)    
    redirect_to car_service_offer
  end

  def confirmed
    @car_service_offers = CarServiceOffer.confirmed.company(company_id)
  end
  
  def reject
    car_service_offer = CarServiceOffer.find params[:id]
    car_service_offer.update_attribute(:status, Status::REJECTED)    
    redirect_to car_service_offer
  end
  
  def change_status new_status 
    
  end
end
