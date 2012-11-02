class AlarmMailer < ActionMailer::Base
  default :from => "ComunidadBox <info@comunidadbox.com>"
  layout "emails"

  def alarm(alarm)
    @alarm = alarm
    @user = @alarm.user
    mail(:to => @user.email,:subject => "notificacion de alarma #{alarm.name}")
  end
end
