class ServiceOffer < ActiveRecord::Base


  has_many :car_service_offer
  has_many :cars, :through => :car_service_offer
  belongs_to :service_type
  belongs_to :company

  validates_numericality_of :price,:final_price,:percent
  validates_presence_of :title, :price, :final_price, :percent
  
  scope :sended ,where("service_offers.status = ?",Status::SENT)
  scope :confirmed, where("service_offers.status = ?",Status::CONFIRMED)
  scope :cars, lambda{|cars_ids| where("car_service_offers.car_id in (?)",cars_ids).includes(:car_service_offer)}
  
  
  STATUS = [
      [ Status.status(Status::OPEN),Status::OPEN ],
      [ Status.status(Status::CONFIRMED), Status::CONFIRMED ],
      [ Status.status(Status::CANCELLED), Status::CANCELLED ]
  ]
  
  def confirmed?
    status == Status::CONFIRMED
  end

  def valid_dates
      dates = []
      dates << "Lunes" if monday
      dates << "Martes" if tuesday
      dates << "Miercoles" if wednesday
      dates << "Jueves" if thursday
      dates << "Viernes" if friday
      dates << "Sabado" if saturday
      dates << "Domingo" if sunday
      dates
  end

  def my_cars user
    car_service_offer.select{|cs| cs.car.user.id == user.id}
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
  

  #Notifico a los autos sus ofertas de servicios
  def self.notify
    #enviar solo a estos autos..prueba
    cars_id = %w"HRJ549 AOK780"
    logger.info "Service Offer notify"
    cars,so = get_service_offer_by_user      
    cars.each do |car,service_offers|        
      if cars_id.include?(car.domain)
        ServiceOffer.transaction do
          debugger
          self.notify_service_offer(car,service_offers) 
          self.update_car_service_offer_status(car,service_offers)
        end
      end    
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
    logger.info "Envio de ServiceOffer #{Time.now} para #{car.domain} #{service_offers.map(&:id).join(',')}"
    message = ServiceOfferMailer.notify(car,service_offers).deliver
  end
end

