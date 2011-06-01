class ServiceOfferMailer < ActionMailer::Base
  default :from => "ComunidadBox <info@comunidadbox.com>"
  layout "emails"
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.service_offer_mailer.notifier.subject
  #
  def notify( car, service_offers)
    @car = car
    @user = car.user
    @service_offers = service_offers
    logger.info "### Car : #{@car.domain} Serivce Offer ID: #{@service_offers.size}"
    mail(:to => car.user.email,:subject => "notificacion de ofertas de servicios")
  end
end
