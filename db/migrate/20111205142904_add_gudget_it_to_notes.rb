class AddGudgetItToNotes < ActiveRecord::Migration
  def self.up
  	add_column :notes, :budget_id, :integer
    add_foreign_key(:notes,:budgets,:dependent => :delete)  
  end

  def self.down
  	remove_column :notes, :budget_id
  end
end
