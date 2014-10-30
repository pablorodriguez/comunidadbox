class ChangeServiceType < ActiveRecord::Migration
  def up
    add_column :service_types, :company_id, :integer
    add_index :service_types, :company_id    
    add_foreign_key(:service_types, :companies)

    add_column :materials, :company_id, :integer
    add_column :materials, :disable, :boolean
    add_index :materials, :company_id 

    add_foreign_key(:materials, :companies)

    add_column :material_service_types, :company_id, :integer
    add_index :material_service_types, :company_id    
    add_foreign_key(:material_service_types, :companies)

    execute "update service_types set company_id=12 where company_id is null"
    execute "update materials set company_id = 12 where company_id is null"
    execute "update material_service_types set company_id = 12 where company_id is null"

  end

  def down
    remove_column :service_types,:company_id    
    remove_column :materials,:company_id
    remove_column :material_service_types,:company_id
    
  end
end

