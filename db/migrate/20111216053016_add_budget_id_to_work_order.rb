class AddBudgetIdToWorkOrder < ActiveRecord::Migration
  def self.up
  	add_column :workorders,:budget_id, :integer
  	add_foreign_key(:workorders,:budget, :column => 'budget_id')
  end

  def self.down
  	remove_column :workorders,:budget_id
  end
end
