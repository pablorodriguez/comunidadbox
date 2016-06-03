class AddDeletedAtToBudgets < ActiveRecord::Migration
  def change
    add_column :budgets, :deleted_at, :datetime
    add_index :budgets, :deleted_at
  end
end
