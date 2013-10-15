class AddMessageToMaterialRequests < ActiveRecord::Migration
  def change
    add_column :material_requests, :message, :string
  end
end
