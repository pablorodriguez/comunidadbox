class Car < ActiveRecord::Base
  has_many :workorders
  has_many :events
  belongs_to :model
  belongs_to :brand
  belongs_to :user
  belongs_to :company
  has_many :car_service_offer
  has_many :service_offers,:through =>  :car_service_offer,:order =>'created_at'
  #has_and_belongs_to_many :offers
  
  validates_presence_of :model,:domain,:year,:km
  validates_numericality_of :year,:km
  validates_uniqueness_of :domain
  validates_format_of :domain, :with => /^\D{3}\d{3}/

  def future_events
    #Event.future(Time.now).car(self.id).order("dueDate desc")
    Event.car(self.id).order("dueDate desc")
  end
  
  def can_edit?(usr)
    (user == usr) || (company == usr.company && user.confirmed_at == nil) 
  end
  
  def update_km(new_km)
    months = ((Time.now.to_i - self.updated_at.to_i).to_f / Event::MONTHS_IN_SEC).round
    if months > 0
      km_dif = new_km - self.km
      new_avg = (km_dif) / months
      self.kmAverageMonthly = new_avg
      self.km = new_km
      end
    
  end
  
  def update_events
    future_events.active.each do |event|
      months = (event.km - km) / kmAverageMonthly
      #old_date = event.dueDate
      e = Event.find event.id
      e.dueDate = months.months.since
      e.save
      #puts "Old Date: #{old_date}, KM: #{event.km} , New Date: #{event.dueDate} Months : #{months}"
    end
    
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

