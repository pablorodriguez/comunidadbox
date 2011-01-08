class UserMailer < ActionMailer::Base
  
  include ActionController::UrlWriter
  default_url_options[:host]= APP_NAME
  
  def confirm(user,host)
    subject    'confirmacion de email'
    recipients user.email
    from       'info@autoasistencia.com'
    sent_on    Time.now
    body       :user => user
  end
end

