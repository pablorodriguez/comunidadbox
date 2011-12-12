class AddCompanyToBudget < ActiveRecord::Migration
  def self.up
  	add_column :budgets,:company_id, :integer
  	add_column :budgets,:car_id,:integer
  	add_column :budgets,:user_id,:integer
    add_column :comment, :text
  	add_foreign_key(:budgets,:users, :column => 'user_id')
  	add_foreign_key(:budgets,:cars,:dependent =>:delete)
    add_foreign_key(:budgets,:companies,:dependent => :delete)  
  end

  def self.down
    remove_column :comment
  	remove_column :budgets, :company_id
  	remove_column :budgets, :car_id
  	remove_column :budgets, :user_id
  end
end
