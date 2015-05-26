class AddVehicleTypeToBudget < ActiveRecord::Migration
  def change
     add_column :budgets, :vehicle_type, :string
  end
end
