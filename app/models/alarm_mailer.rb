class AlarmMailer < ActionMailer::Base
  def alarm(user, alarm)
    subject 'Alarma programada brindada por Comunidad Box'
    recipients user.email
    from 'info@comunidadbox.com'
    sent_on Time.now
    body :user => user, :alarm => alarm
    content_type "text/html"
  end

end

