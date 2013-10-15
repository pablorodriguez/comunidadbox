class AddMaterialToMaterialRequest < ActiveRecord::Migration
  def change
    add_column :material_requests, :material, :integer
  end
end
