class AddBudgetToService < ActiveRecord::Migration
  def self.up
    add_column :services, :budget_id, :integer
    add_foreign_key(:services,:budgets,:dependent => :delete)  
  end
  

  def self.down
    remove_column :services, :budget_id
  end
end
