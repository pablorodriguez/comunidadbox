class EventMailer < ActionMailer::Base
  

  def sent(user,work_order)
    subject    'notificación servicio realizado'
    recipients work_order.car.user.email
    from       'info@comunidadbox.com'
    sent_on    Time.now
    body       :user => user,:work_order => work_order
    content_type "text/html"
  end

end
