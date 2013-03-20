class CreateMaterialServiceTypeTemplates < ActiveRecord::Migration
   def up
    create_table :material_service_type_templates do |t|
      
      t.references :service_type_template
      t.references :material_service_type
      t.string :material
      t.integer :amount
      t.timestamps
    end

    add_foreign_key(:material_service_type_templates,:service_type_templates, :dependent => :delete)
    
  end

  def down
    drop_table :material_service_type_templates
  end
end
