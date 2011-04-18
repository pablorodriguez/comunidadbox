class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.references :state
      t.references :user
      t.references :company
      t.string :city
      t.string :street
      t.string :zip
      t.integer :user_id
      t.string  :name
      t.decimal :lat,:precision =>14
      t.decimal :lng,:precision =>14
      t.timestamps
    end
    
    add_foreign_key(:addresses,:states)
    add_foreign_key(:addresses,:users,:dependent => :delete)
    add_foreign_key(:addresses,:companies,:dependent => :delete)
    
  end

  def self.down
    drop_table :addresses
  end
end
