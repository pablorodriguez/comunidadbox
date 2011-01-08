class ServiceOfferMailer < ActionMailer::Base
  
  def send_service_offer(car,service_offers)
    user = car.user
    subject    'listado oferta de servicios'
    recipients user.email
    bcc ['admin@comunidadbox.com.ar','pablorodriguez.ar@gmail.com','gdeantonio@yahoo.com.ar']
    from       'info@autoasistencia.com'
    sent_on    Time.now
    body       :user => user,:service_offers =>service_offers
  end

end
