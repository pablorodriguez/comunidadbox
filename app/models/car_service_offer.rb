class CarServiceOffer < ActiveRecord::Base
  default_scope order('created_at DESC')
  belongs_to :car
  belongs_to :service_offer
  belongs_to :service
  
  scope :acepted, where("car_service_offers.status = ?", Status::CONFIRMED)
  scope :cars, lambda{|car_id |where("car_id =?",car_id)}
  scope :company , lambda{|company_ids| where("service_offers.company_id IN (?)",company_ids).includes(:service_offer)}
  scope :by_status,lambda{|status| where("car_service_offers.status = ?",status)}
  
  def self.update_with_services(services,cso_ids)
    car_service_offers = CarServiceOffer.find cso_ids
    services.each do |s|
      car_service_offers.each do |cso|
        if (cso.service_offer.service_type.id == s.service_type.id)
          if (s.status == Status::FINISHED)
            cso.service = s
            cso.status = Status::PERFORMED
          else
            cso.status = Status::CONFIRMED
            cso.service = nil  
          end
          cso.save
        end
      end
    end
  end
end
