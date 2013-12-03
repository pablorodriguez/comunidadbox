class ServiceOffer < ActiveRecord::Base
  include Statused  
  attr_accessible :offer_service_types_attributes, :service_type_id, :title, :status, :comment, :price, :percent,:service_type, :final_price, :since, :until, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :offer_service_types,:company_id,:service_request_id

  has_many :car_service_offers
  has_many :cars, :through => :car_service_offers
  has_many :offer_service_types
  has_many :service_types,:through => :offer_service_types
  belongs_to :company
  belongs_to :service_request

  validates_numericality_of :price,:final_price,:percent
  validates_presence_of :title, :price, :final_price, :percent
  accepts_nested_attributes_for :offer_service_types,:reject_if => lambda { |m| m[:service_type_id].blank? }, :allow_destroy => true
  
  default_scope {order("service_offers.created_at DESC")}
  scope :sended ,where("service_offers.status = ?",Status::SENT)  
  scope :confirmed, where("service_offers.status = ?",Status::CONFIRMED)
  scope :cars, lambda{|cars_ids| where("car_service_offers.car_id in (?)",cars_ids).includes(:car_service_offers)}
  validate :validate_service_types


  def validate_service_types
    errors.add(:service_types, "debe tener al menos un tipo de servicio") if offer_service_types.length == 0
  end

  def build_offer_service_types service_types
    service_types.each do |st|
      if company_id
        c = Company.find company_id
        if c.perform_service_type?(st)
          self.offer_service_types.build(service_type: st)
        end
      end
    end
  end

  def service_types_names
    offer_service_types.map{|ost| ost.service_type.name}.join(" - ")    
  end

  def valid_dates
    days = []
    days << "sunday" if self.sunday
    days << "monday" if self.monday
    days << "tuesday" if self.tuesday
    days << "wednesday" if self.wednesday
    days << "thursday" if self.thursday
    days << "friday" if self.friday
    days << "saturday" if self.saturday  
    days
  end

  def my_cars user
    car_service_offers.select{|cs| cs.car.user.id == user.id}
  end

  #Busco las ofertas de servicio y las agrupo por auto
  def self.get_service_offer_by_user
    cars = Hash.new
    service_offers = ServiceOffer.confirmed
    
    service_offers.each do |s|            
      s.cars.each do |c|
        unless cars[c]
          cars[c]=Array.new
        end         
        cars[c] << s
      end
    end
    
    return cars,service_offers
  end
  
  #if user's car belong to service offer car the user can see it
  def can_show? user
    cars_ids = user.cars.map(&:id)
    CarServiceOffer.where("service_offer_id = ? and car_id IN(?)",self.id,cars_ids).count > 0    
  end

  #Notifico a los autos sus ofertas de servicios
  def self.notify
    #enviar solo a estos autos..prueba
    cars_id = %w"HRJ549 AOK780"
    logger.info "Service Offer notify"
    cars,so = get_service_offer_by_user      
    cars.each do |car,service_offers|        
      #if cars_id.include?(car.domain)
        ServiceOffer.transaction do
          self.notify_service_offer(car,service_offers) 
          self.update_car_service_offer_status(car,service_offers)
        end
      #end    
    end
  
    #Actualizo el estado de cada Oferta de Servicio a SENT    
    so.each {|s| s.update_attributes(status: Status::SENT)}

  end
  
  #Actualizo el estado de la oferta de servicio del auto a SENT
  def self.update_car_service_offer_status(car,service_offers)
    service_offers.each do |so|
      CarServiceOffer.where("car_id = ? and service_offer_id = ?",car.id,so.id).update_all(status: Status::SENT)
    end  
  end



  private
  
  def self.notify_service_offer(car,service_offers)
    logger.info "Envio de ServiceOffer #{Time.zone.now} para #{car.domain} #{service_offers.map(&:id).join(',')}"
    message = ServiceOfferMailer.notify(car,service_offers).deliver
  end
end

