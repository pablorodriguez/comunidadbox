class AddMaterialToMaterialRequest < ActiveRecord::Migration
  def change
    add_column :material_requests, :material_id, :integer

    add_foreign_key(:material_requests,:materials)
  end
end
