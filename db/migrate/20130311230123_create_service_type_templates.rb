class CreateServiceTypeTemplates < ActiveRecord::Migration
  def up
    create_table :service_type_templates do |t|
      t.string :name  
      t.references :service_type    
      t.references :company
      t.timestamps
    end
    add_foreign_key(:service_type_templates,:service_types)
    add_foreign_key(:service_type_templates,:companies)
    
  end

  def down
    drop_table :service_type_templates
  end
end
