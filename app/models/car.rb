class Car < ActiveRecord::Base
  has_many :workorders
  has_many :budgets
  has_many :events
  belongs_to :model
  belongs_to :brand
  belongs_to :user
  belongs_to :company
  has_many :car_service_offer
  has_many :service_offers,:through =>  :car_service_offer,:order =>'created_at'
  #has_and_belongs_to_many :offers
  
  validates_presence_of :model,:domain,:year,:km,:kmAverageMonthly
  validates_numericality_of :year,:km,:kmAverageMonthly
  validates_uniqueness_of :domain
  validates_format_of :domain, :with => /^\D{3}\d{3}/
  before_save :set_new_attribute
  after_save :update_events

  def self.fuels
    %w(Nafta Diesel Gas)
  end

  def set_new_attribute
    # si se modifico el km 
    # pero no se modificio el kmAverageMonthly
    # calculo el kmAverageMonthly    
    if (km_changed? && (!kmAverageMonthly_changed?))
      update_kmUpdatedAt
    end

    if self.new_record?
      kmUpdatedAt = DateTime.new
    end
  end

  def update_km?
    (self.kmUpdatedAt && (Time.now - self.kmUpdatedAt) < (60 * 60 * 24)) ? false : true
  end

  def future_events
    #Event.future(Time.now).car(self.id).order("dueDate desc")
    Event.car(self.id).active.order("dueDate desc")
  end
  
  def can_edit?(usr)
    (user.id == usr.id) || ((company && company.id == usr.company.id) && user.confirmed_at.nil?) 
  end
    
  def total_spend(company_id = nil,service_type_id = nil)
    total = 0
    self.workorders.each do  |wo|
      if (company_id == nil or company_id.include?(wo.company_id.to_s))
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

  def self.companies ids
    Car.includes(:company).where("cars.company_id IN (?)",ids)
  end

  private

  def update_kmUpdatedAt
    last_update = self.kmUpdatedAt.nil? ? self.updated_at : self.kmUpdatedAt
    months = ((Time.now.to_i - last_update.to_i).to_f / Event::MONTHS_IN_SEC).round
    if months > 0
      km_dif = self.km - self.changed_attributes["km"]
      new_avg = (km_dif) / months
      self.kmAverageMonthly = new_avg        
      self.kmUpdatedAt = Time.new 
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
end

