class Service < ActiveRecord::Base
  belongs_to :workorder
  belongs_to :service_type
  has_one :car_service_offer
  has_many :material_services
  has_many :events
  has_and_belongs_to_many :tasks
   
  accepts_nested_attributes_for :material_services, :allow_destroy => true
  accepts_nested_attributes_for :car_service_offer
  accepts_nested_attributes_for :service_type
  
  def total_price
    m_total_price=0
    if car_service_offer
      m_total_price = car_service_offer.service_offer.final_price
    else
      material_services.each do |m|
        m_total_price += m.total_price
      end
    end
    
    m_total_price
  end
  
  def cancelled
    status == Status::CANCELLED
  end
end
