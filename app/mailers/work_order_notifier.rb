class WorkOrderNotifier < ActionMailer::Base
  default :from => "ComunidadBox <info@comunidadbox.com>"
  layout "emails"
  
  def notify(work_order)
    @work_order = work_order
    @user = work_order.car.user
    mail(:to => @user.email,:subject => "notificacion de servicios realizados")
  end
end
