class Service < ActiveRecord::Base
  belongs_to :workorder
  belongs_to :service_type
  has_many :material_services
  has_many :events
  has_and_belongs_to_many :tasks
   
  accepts_nested_attributes_for :material_services, :allow_destroy => true
  
  accepts_nested_attributes_for :service_type
  
  def total_price
    m_total_price=0
    self.material_services.each do |m|
      m_total_price += m.total_price
    end
    m_total_price
  end
  
  def cancelled
    status == "Cancelado"
  end
end
