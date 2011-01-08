class CarServiceOfferController < ApplicationController
  
  def show
    @offer = CarServiceOffer.find params[:id]
  end
  
  def index
    @offers = CarServiceOffer.find(:all,:conditions=>["service_offers.company_id = ? and car_service_offers.status in (?)",current_user.company.id,
    ['Aceptado']],:include =>[:service_offer ,:car])
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
    redirect_to list_service_offer_users_path
  end
end
