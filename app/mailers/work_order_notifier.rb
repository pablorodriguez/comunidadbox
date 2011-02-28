class WorkOrderNotifier < ActionMailer::Base
  default :from => "ComunidadBox <info@lincar.com.ar>"
  layout "emails"
  
  def notify(work_order)
    @work_order = work_order
    @user = work_order.car.user
    attachments.inline["company-logo.png"] = File.read(Rails.root.join('public', 'images', 'company-logo.png'))
    mail(:to => @user.email,:subject => "notificacion de servicios realizados")
    
  end
end
