class AddCustomStatusIdToBudget < ActiveRecord::Migration
  def change
    add_column :budgets, :custom_status_id, :integer
  end
end
