class CarServiceOffer < ActiveRecord::Base
  include Statused  

  default_scope order('car_service_offers.created_at DESC')
  belongs_to :car
  belongs_to :service_offer
  has_one :service

  scope :confirmed, where("car_service_offers.status = ?", Status::CONFIRMED)
  scope :cars, lambda{|car_id |where("car_id =?",car_id)}
  scope :company , lambda{|company_ids| where("service_offers.company_id IN (?)",company_ids).includes(:service_offer)}
  scope :by_status,lambda{|status| where("car_service_offers.status = ?",status)}  
  
  def self.update_with_services(services)
    services.each do |s|
      if s.car_service_offer_id
        debugger
        car_service_offers = CarServiceOffer.find s.car_service_offer_id
        car_service_offers.status = Status::PERFORMED
        car_service_offers.service_id = s.id
        car_service_offers.save                
      end
      
    end
  end

  def valid_dates
    service_offer.valid_dates
  end

  def have_valid_dates?
    valid_dates.size > 0
  end

  def is_not_valid_today?
    !is_valid_today?
  end

  def is_valid_today?
    now = Time.now.to_date
    if self.service_offer.since <= now and self.service_offer.until >= now
      if have_valid_dates?
        day_name = Time.now.strftime("%A").downcase
        return valid_dates.include?(day_name) ? true : false
      else
        return true
      end
    else
      return false
    end
    
  end

  def self.search_for(car_ids,company_ids)
    cso = CarServiceOffer.cars(car_ids).company(company_ids).includes(:service_offer)
    cso = cso.where("service_offers.since <= :DATE and service_offers.until >= :DATE",:DATE => Time.now)
    cso = cso.joins("LEFT JOIN services ON services.car_service_offer_id=car_service_offers.id").where("services.id is null")
    cos.delete_if{|offer| offer.is_not_valid_today?}
    cso
  end

end
