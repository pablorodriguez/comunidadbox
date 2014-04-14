class CreateCompanyMaterialCodes < ActiveRecord::Migration
  def change
    create_table :company_material_codes do |t|
      t.string :code
      t.references :company
      t.references :material_service_type

      t.timestamps
    end
    add_index :company_material_codes, :company_id
    add_index :company_material_codes, :material_service_type_id
    add_foreign_key(:company_material_codes, :companies)
    add_foreign_key(:company_material_codes, :material_service_types)

  end
end
