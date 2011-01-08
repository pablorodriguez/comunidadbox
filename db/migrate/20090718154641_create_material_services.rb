class CreateMaterialServices < ActiveRecord::Migration
  def self.up
    create_table :material_services do |t|
      t.references :service
      t.integer :amount
      t.float :price
      t.string :material
      t.references :material_service_type
      t.timestamps
    end 
    
    add_foreign_key(:material_services,:services, :dependent => :delete)
    add_foreign_key(:material_services,:material_service_types)
  end

  def self.down
    drop_table :material_services
  end
end
