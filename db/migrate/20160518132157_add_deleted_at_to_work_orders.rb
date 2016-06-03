class AddDeletedAtToWorkOrders < ActiveRecord::Migration
  def change
    add_column :workorders, :deleted_at, :datetime
    add_index :workorders, :deleted_at
  end
end
