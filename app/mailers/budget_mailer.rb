class BudgetMailer < ActionMailer::Base  
  default :from => "ComunidadBox <info@comunidadbox.com>"
  layout "emails"
  
  def email(budget)
    @budget = budget
    @client = @budget
    @client = @budget.user if @budget.user
    @client = @budget.car.user if @budget.car

    @car = @budget
    @car = @budget.car if @budget.car 
    
    mail(:to => @client.email,:subject => "presupuesto #{budget.creator.company.name} Nro: #{budget.id}")
  end
end
