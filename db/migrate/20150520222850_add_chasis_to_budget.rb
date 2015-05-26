class AddChasisToBudget < ActiveRecord::Migration
  def change
      add_column :budgets, :chassis, :string
  end
end
