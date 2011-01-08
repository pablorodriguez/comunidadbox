class CreateServiceFilters < ActiveRecord::Migration
  def self.up
    create_table :service_filters do |t|
      t.string :fuel
      t.integer :year
      t.string :city
      t.string :name
      t.references :service_type 
      t.references :model
      t.references :brand
      t.references :state
      t.references :user
      t.timestamps
    end
    
    add_foreign_key(:service_filters,:service_types,:dependent => :delete)
    add_foreign_key(:service_filters,:models,:dependent => :delete)
    add_foreign_key(:service_filters,:brands,:dependent => :delete)
    add_foreign_key(:service_filters,:states,:dependent => :delete)
    add_foreign_key(:service_filters,:users,:dependent => :delete)
    
  end

  def self.down
    drop_table :filters
  end
end
