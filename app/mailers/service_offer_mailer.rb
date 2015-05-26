# encoding: utf-8
class ServiceOfferMailer < ActionMailer::Base
  default :from => "ComunidadBox <info@comunidadbox.com>"
  layout "emails"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.service_offer_mailer.notifier.subject
  #
  def notify(vehicle, service_offers)
    @vehicle = vehicle
    @user = vehicle.user
    @service_offers = service_offers

    ServiceOffer.transaction do
      mail(:to => vehicle.user.email,:subject => "notificacion de ofertas de servicios")
    end
  end
end
