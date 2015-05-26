# encoding: utf-8
class BudgetMailer < ActionMailer::Base
  default :from => "ComunidadBox <info@comunidadbox.com>"
  layout "emails"

  def email(budget)
    @budget = budget
    @client = @budget
    @client = @budget.user if @budget.user
    @client = @budget.vehicle.user if @budget.vehicle

    @vehicle = @budget
    @vehicle = @budget.vehicle if @budget.vehicle

    mail(:to => @client.email,:subject => "presupuesto #{budget.creator.company.name} Nro: #{budget.id}")
  end
end
