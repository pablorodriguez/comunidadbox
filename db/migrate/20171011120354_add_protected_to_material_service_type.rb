class AddProtectedToMaterialServiceType < ActiveRecord::Migration
  def change
    add_column :material_service_types, :protected, :boolean
  end
end
