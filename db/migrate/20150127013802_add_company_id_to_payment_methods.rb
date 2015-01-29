class AddCompanyIdToPaymentMethods < ActiveRecord::Migration
  def change
    add_column :payment_methods, :company_id, :integer
  end
end
