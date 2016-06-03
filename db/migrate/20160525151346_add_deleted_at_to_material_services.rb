class AddDeletedAtToMaterialServices < ActiveRecord::Migration
  def change
    add_column :material_services, :deleted_at, :datetime
    add_index :material_services, :deleted_at
  end
end
