class CreateMaterialServiceTypes < ActiveRecord::Migration
  def self.up
    create_table :material_service_types do |t|
      t.references :material
      t.references :service_type
      t.timestamps
    end
    
    add_foreign_key(:material_service_types,:materials)
    add_foreign_key(:material_service_types,:service_types)
    
    add_index :material_service_types,:service_type_id 
    
  end

  def self.down
    drop_table :material_service_types
  end
end
