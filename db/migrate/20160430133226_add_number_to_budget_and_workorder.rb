class AddNumberToBudgetAndWorkorder < ActiveRecord::Migration
  def change
    add_column :budgets, :nro, :integer
    add_column :workorders, :nro, :integer
  end
end
