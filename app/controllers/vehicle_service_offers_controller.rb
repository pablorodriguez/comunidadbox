# encoding: utf-8
class VehicleServiceOffersController < ApplicationController

  def show
    @vehicle_service_offer = VehicleServiceOffer.find params[:id]
    authorize! :read, @vehicle_service_offer
  end

  def index
    @vehicle_service_offers = VehicleServiceOffer.search_by_vehicles_ids(current_user.vehicles_ids)
  end

  def confirm
    vehicle_service_offer = VehicleServiceOffer.find params[:id]
    vehicle_service_offer.update_attribute(:status, Status::CONFIRMED)
    redirect_to vehicle_service_offer
  end

  def confirmed
    @vehicle_service_offers = VehicleServiceOffer.confirmed.company(company_id)
  end

  def reject
    vehicle_service_offer = VehicleServiceOffer.find params[:id]
    vehicle_service_offer.update_attribute(:status, Status::REJECTED)
    redirect_to vehicle_service_offer
  end

  def change_status new_status

  end
end
