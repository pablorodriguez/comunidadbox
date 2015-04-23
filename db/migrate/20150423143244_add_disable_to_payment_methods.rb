class AddDisableToPaymentMethods < ActiveRecord::Migration
  def change
    add_column :payment_methods, :active, :boolean
    execute "update payment_methods set active=1"
  end
end
