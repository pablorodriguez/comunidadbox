# encoding: utf-8
class CreateVehicleMotorcycles < ActiveRecord::Migration
  def change
    create_table :vehicle_motorcycles do |t|
      t.string :chassis
      t.references :motorcycle

      t.timestamps
    end
    add_index :vehicle_motorcycles, :motorcycle_id

  end
end
