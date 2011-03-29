class Car < ActiveRecord::Base
  has_many :workorders
  has_many :events
  belongs_to :model
  belongs_to :brand
  belongs_to :user
  belongs_to :company
  #has_and_belongs_to_many :offers
  
  validates_presence_of :model,:domain,:year,:km
  validates_numericality_of :year,:km
  validates_uniqueness_of :domain
  validates_format_of :domain, :with => /^\D{3}\d{3}/

  def future_events
    Event.all(:conditions =>["dueDate >= ? and car_id = ?",Time.now,self.id])
  end

  def total_spend(company_id = nil,service_type_id = nil)
    total = 0
    self.workorders.each do  |wo|
      if (company_id == nil or company_id == wo.company_id)
        wo.services.each do |s|
          total += s.total_price unless service_type_id
          total += s.total_price if (service_type_id && s.service_type.id == service_type_id)
        end
      end
    end
    total
  end
  
  def info
    "#{domain} #{brand.name} #{model.name} #{year} #{fuel}"
  end
end

