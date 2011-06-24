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

  def self.get_service_offer_by_user
    users = Hash.new
    service_offers = ServiceOffer.where(["status = ?",Status::CONFIRMED])
    
    service_offers.each do |s|
      s.status = Status::SENT
      s.save
      
      s.car_service_offer.each do |cs|
        cs.status = Status::SENT
        cs.save
      end
      
      s.cars.each do |c|
        unless users[c]
          users[c]=Array.new
        end         
        users[c] << s
      end
    end
    
    users
  end
  
  def my_cars user
    car_service_offer.select{|cs| cs.car.user.id == user.id}
  end

  def self.notify
    ServiceOffer.transaction do
      users = get_service_offer_by_user
      users.each do |key,value|
        self.notify_service_offer(key,value)
      end
    end
  end
  
  private
  
  def self.notify_service_offer(car,service_offers)
    message = ServiceOfferMailer.notify(car,service_offers).deliver
  end
end

