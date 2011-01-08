class ServiceOffer < ActiveRecord::Base
  has_many :car_service_offer
  has_many :cars, :through => :car_service_offer
  belongs_to :service_type
  belongs_to :company

  validates_numericality_of :price,:final_price,:percent

  validates_presence_of :title, :price, :final_price, :percent

  STATUS_TYPES = [
    [ 'Abierto' , 'Abierto' ],
    [ 'Pendiente' , 'Pendiente' ],
    [ 'Confirmado' , 'Confirmado' ],
    [ 'Cancelado' , 'Cancelado' ],
    [ 'Enviado' , 'Enviado' ]
  ]

  def self.get_service_offer_by_user
    users = Hash.new
    service_offers = ServiceOffer.all(:conditions=>["status ='Confirmado'"])
    
    service_offers.each do |s|
      s.status ="Enviado"
      s.save
      
      s.car_service_offer.each do |cs|
        cs.status ="Enviado"
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

  def self.send_notification
    users = get_service_offer_by_user
    users.each do |key,value|
      send_service_offer(key,value)
    end
  end
  
  private
  
  def self.send_service_offer(car,service_offers)
     email = ServiceOfferMailer.create_send_service_offer(car,service_offers)
     email.set_content_type("text/html")
     ServiceOfferMailer.deliver email  
  end
end

