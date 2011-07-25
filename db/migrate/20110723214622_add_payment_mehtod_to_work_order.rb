class AddPaymentMehtodToWorkOrder < ActiveRecord::Migration
  def self.up
    add_column :workorders, :payment_method_id,:integer
    add_foreign_key(:workorders,:payment_methods)
  end

  def self.down
    remove_column :workorders,:payment_method_id
  end
  
end
