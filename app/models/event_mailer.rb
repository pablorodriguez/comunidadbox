# encoding: utf-8
class EventMailer < ActionMailer::Base

  def sent(user,work_order)
    subject    'notificacion servicio realizado'
    recipients work_order.vehicle.user.email
    from       'info@comunidadbox.com'
    sent_on    Time.zone.now
    body       :user => user,:work_order => work_order
    content_type "text/html"
  end

end
