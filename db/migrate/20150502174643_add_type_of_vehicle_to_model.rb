class AddTypeOfVehicleToModel < ActiveRecord::Migration
  def change
    add_column :models, :type_of_vehicle, :integer
  end
end
