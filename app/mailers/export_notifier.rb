class ExportNotifier < ActionMailer::Base
  default :from => "ComunidadBox <info@comunidadbox.com>"
  layout "emails"
  
  def notify(export)
    @user = export.user
    mail(:to => @user.email,:subject => "notificacion de archivos generados")
  end
end
