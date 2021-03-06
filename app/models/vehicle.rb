# encoding: utf-8
class Vehicle < ActiveRecord::Base
  attr_accessible :km, :kmAverageMonthly, :domain, :brand_id, :brand, :year, :model_id, :model, :fuel, :user_id, :vehicle_type, :chassis

  has_many :workorders,:dependent=>:destroy
  has_many :budgets,:dependent=>:destroy
  has_many :events,:dependent=>:destroy
  has_many :notes,:dependent=>:destroy

  belongs_to :model
  belongs_to :brand
  belongs_to :user
  belongs_to :company
  has_many :vehicle_service_offer
  has_many :service_offers,:through =>  :vehicle_service_offer,:order =>'created_at'
  #has_and_belongs_to_many :offers

  validates_presence_of :brand,:model,:year
  validates_numericality_of :year, :only_integer => true, :greater_than_or_equal_to => 1885
  validates_numericality_of :km, :only_integer => true
  validates_numericality_of :kmAverageMonthly,:only_integer => true
 
  validate :custom_validations
  before_save :set_new_attribute
  after_save :update_events

  # scope :cars, -> { where(type: 'Car') }
  # scope :motorcycles, -> { where(type: 'Motorcycle') }
  scope :cars, -> { where(vehicle_type: 'Car') }
  scope :motorcycles, -> { where(vehicle_type: 'Motorcycle') }

  attr_accessor :today_service_offer

  after_initialize do |vehicle|
    vehicle.vehicle_type = 'Car' unless vehicle.vehicle_type
  end

  def custom_validations
    if vehicle_type == "Car" and domain.nil?
      errors[:domain] << "El Dominio no puede estar vacio"
    end

    if domain && !domain.empty? && !valid_domain_format?
      errors[:domain] << "El Formato del Dominio es incorrecto"
    end
    
  end

  def valid_domain_format?
    return true
    pattern = /^\D\D\D\d\d\d/
    if is_motorcycle?
      pattern = /^\d\d\d\D\D\D/
    end
    pattern.match self.domain
  end

  def self.fuels
    %w(Nafta Diesel Gas)
  end

  def search_service_offer companies_ids
    @today_service_offer ||=  VehicleServiceOffer.search_for(self.id,companies_ids)
  end

  def have_multiple_service_offer company_ids
    vehicle_service_offer = search_service_offer(company_ids)
    return false if vehicle_service_offer.size <= 1

    vehicle_service_offer.service_offer.service_types.map(&:id)

  end

  def set_new_attribute
    # si se modifico el km
    # pero no se modifico el kmAverageMonthly
    # calculo el kmAverageMonthly
    if (km_changed? && (!kmAverageMonthly_changed?))
      update_kmUpdatedAt
    end

    if self.new_record?
      self.kmUpdatedAt = Time.new
    end
  end

  def update_km?
    (self.kmUpdatedAt && (Time.zone.now - self.kmUpdatedAt) < (60*60*24)) ? false : true
  end

  def future_events
    Event.vehicle(self.id).active.order("dueDate asc")
  end

  def can_delete?(usr)
    can_edit?(usr)
  end

  def can_edit?(usr)
    self.user.can_edit?(usr)
    #(user.id == usr.id) || ((company && company.id == usr.company.id) && user.confirmed_at.nil?)
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
    # Vehicle.includes(:company).where("vehicles.company_id IN (?)",ids)
    Vehicle.includes(:company).where(company_id: ids)
  end

  def update_events
    future_events.active.readonly(false).each do |event|      
      if event.km 
        months = (event.km - km) / kmAverageMonthly
        event.dueDate = months.months.since.to_date
        event.save      
      end
    end
  end

  def update_kmUpdatedAt
    last_update = self.kmUpdatedAt.nil? ? self.updated_at : self.kmUpdatedAt
    months = ((Time.zone.now.to_i - last_update.to_i).to_f / Event::MONTHS_IN_SEC).round
    if months > 0
      km_dif = self.km - self.changed_attributes["km"]
      new_avg = (km_dif) / months
      self.kmAverageMonthly = new_avg
      self.kmUpdatedAt = Time.new
    end
  end

  def budgets_for user
    if user.is_employee?
      budgets.where("company_id IN (?)",user.get_companies_ids)
    else
      budgets
    end
  end
  def is_car?
    self.vehicle_type == "Car"
  end

  def is_motorcycle?
    self.vehicle_type == "Motorcycle"
  end

  def self.to_builder vehicles
    Jbuilder.encode do |json|
      json.array! vehicles do |vehicle|
        json.id vehicle.id
        json.domain vehicle.domain
      end
    end
  end

  def self.vehicles
    %w(Car Motorcycle)
  end

end
