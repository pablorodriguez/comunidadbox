class AddCustomStatusIdToWorkorder < ActiveRecord::Migration
  def change
    add_column :workorders, :custom_status_id, :integer
  end
end
