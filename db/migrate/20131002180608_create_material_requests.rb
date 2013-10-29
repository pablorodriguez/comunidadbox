class CreateMaterialRequests < ActiveRecord::Migration
  def change
    create_table :material_requests do |t|
      t.references :user
      t.references :company
      t.references :service_type
      t.text :description
      t.string :provider
      t.integer :cod_provider
      t.string :trademark
      t.string :status

      t.timestamps
    end
    add_index :material_requests, :user_id
    add_index :material_requests, :company_id
    add_index :material_requests, :service_type_id
    add_foreign_key(:material_requests,:users)
    add_foreign_key(:material_requests,:companies)
    add_foreign_key(:material_requests,:service_types)
   
  end
end
