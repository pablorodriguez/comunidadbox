class AddCompanyIdToPaymentMethods < ActiveRecord::Migration
  def change
    add_column :payment_methods, :company_id, :integer

    compamy_payment_methods = {}

    Company.where("headquarter=1").each do |c|
    	ids = c.user.companies.map(&:id).join(",")
    	p = PaymentMethod.create(company_id: c.id,name: "Efectivo")
    	#execute "update workorders set payment_method_id = #{p.id} where company_id IN (#{ids}) and payment_method_id = 1"

    	p = PaymentMethod.create(company_id: c.id,name: "Tarjeta Debito")
    	#execute "update workorders set payment_method_id = #{p.id} where company_id IN (#{ids}) and payment_method_id = 2"

    	p = PaymentMethod.create(company_id: c.id,name: "Tarjeta Credito")
    	#execute "update workorders set payment_method_id = #{p.id} where company_id IN (#{ids}) and payment_method_id = 3"
    	
    	p = PaymentMethod.create(company_id: c.id,name: "Cheque")
    	#execute "update workorders set payment_method_id = #{p.id} where company_id IN (#{ids}) and payment_method_id = 4"

    end
  end
end
