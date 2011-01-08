class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :first_name,                :string
      t.column :last_name,                 :string
      t.column :email,                     :string
      t.column :phone,                     :string,:limit =>15
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :employer_id,                :integer
      t.column :creator_id,                :integer
    end
    
    add_foreign_key(:users,:companies, :column => 'employer_id')
    add_foreign_key(:companies,:users)
  end

  def self.down
    drop_table "users"
  end
end
