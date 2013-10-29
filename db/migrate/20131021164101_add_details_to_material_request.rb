class AddDetailsToMaterialRequest < ActiveRecord::Migration
  def change
    add_column :material_requests, :details, :text
  end
end
