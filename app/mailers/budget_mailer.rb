class BudgetMailer < ActionMailer::Base  
  default :from => "ComunidadBox <info@comunidadbox.com>"
  layout "emails"
  
  def email(budget)
    @budget = budget    
    mail(:to => budget.email,:subject => "presupuesto")
  end
end
