# encoding: utf-8
class AddChassisToVehicle < ActiveRecord::Migration
  def up
    remove_index :vehicle_motorcycles, :motorcycle_id
    drop_table :vehicle_motorcycles

    add_column :vehicles, :chassis, :string

  end

  def down
    remove_column :vehicles, :chassis

    create_table :vehicle_motorcycles do |t|
      t.string :chassis
      t.references :motorcycle

      t.timestamps
    end
    add_index :vehicle_motorcycles, :motorcycle_id

  end

end
