class ContactMailer < ActionMailer::Base
  
  default :to => "ComunidadBox <info@comunidadbox.com>"
  layout "emails"

  def email(contact)
    @contact = contact    
    mail(:from => @contact.from,:subject =>"pregunta")
  end

end
