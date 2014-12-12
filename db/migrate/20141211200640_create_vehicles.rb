# encoding: utf-8
class CreateVehicles < ActiveRecord::Migration
  def up
    rename_table :cars, :vehicles
    add_column :vehicles, :type, :string, default: 'Car'
    add_index :vehicles, :type

    rename_column :alarms, :car_id, :vehicle_id

    remove_foreign_key :budgets, :cars
    remove_index :budgets, name: 'budgets_car_id_fk'
    rename_column :budgets, :car_id, :vehicle_id
    add_foreign_key :budgets, :vehicles, dependent: :delete

    remove_foreign_key :car_service_offers, name: 'car_service_offers_ibfk_1'
    remove_index :car_service_offers, name: 'car_service_offers_car_id_fk'
    rename_column :car_service_offers, :car_id, :vehicle_id
    add_foreign_key :car_service_offers, :vehicles, dependent: :delete

    rename_column :events, :car_id, :vehicle_id

    remove_foreign_key :notes, :cars
    remove_index :notes, name: 'notes_car_id_fk'
    rename_column :notes, :car_id, :vehicle_id
    add_foreign_key :notes, :vehicles, dependent: :delete

    rename_column :service_requests, :car_id, :vehicle_id

    remove_foreign_key :workorders, :cars
    remove_index :workorders, name: 'workorders_car_id_fk'
    rename_column :workorders, :car_id, :vehicle_id
    add_foreign_key :workorders, :vehicles
  end

  def down
    remove_index :vehicles, :type
    remove_column :vehicles, :type
    rename_table :vehicles, :cars

    rename_column :alarms, :vehicle_id, :car_id

    remove_foreign_key :budgets, :vehicles
    remove_index :budgets, name: 'budgets_vehicle_id_fk'
    rename_column :budgets, :vehicle_id, :car_id
    add_foreign_key :budgets, :cars, dependent: :delete

    remove_foreign_key :car_service_offers, :vehicles
    rename_column :car_service_offers, :vehicle_id, :car_id
    add_index :car_service_offers, :car_id, name: 'car_service_offers_car_id_fk'
    add_foreign_key :car_service_offers, :cars, name: 'car_service_offers_ibfk_1', dependent: :delete

    rename_column :events, :vehicle_id, :car_id

    remove_foreign_key :notes, :vehicles
    remove_index :notes, name: 'notes_vehicle_id_fk'
    rename_column :notes, :vehicle_id, :car_id
    add_foreign_key :notes, :cars, dependent: :delete

    rename_column :service_requests, :vehicle_id, :car_id

    remove_foreign_key :workorders, :vehicles
    remove_index :workorders, name: 'workorders_vehicle_id_fk'
    rename_column :workorders, :vehicle_id, :car_id
    add_foreign_key :workorders, :cars
  end

end
