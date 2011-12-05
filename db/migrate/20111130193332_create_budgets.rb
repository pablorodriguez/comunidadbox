class CreateBudgets < ActiveRecord::Migration
  def self.up
    create_table :budgets do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.integer :creator_id
      t.string :email
      t.integer :brand_id
      t.integer :model_id
      t.string :domain
      t.integer :user_id
      t.integer :car_id
      t.timestamps
    end
  end

  def self.down
    drop_table :budgets
  end
end
