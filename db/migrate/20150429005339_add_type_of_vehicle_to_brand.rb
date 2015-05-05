class AddTypeOfVehicleToBrand < ActiveRecord::Migration
  def change
    add_column :brands, :of_cars, :boolean
    add_column :brands, :of_motorcycles, :boolean
  end
end
