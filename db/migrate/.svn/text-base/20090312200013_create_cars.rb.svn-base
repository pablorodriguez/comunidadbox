class CreateCars < ActiveRecord::Migration
  def self.up
    create_table :cars do |t|
      t.string :domain
      t.references :model
      t.references :brand
      t.integer :year
      t.integer :km
      t.integer :kmAverageMonthly
      t.boolean :public
      t.integer :user_id
      t.string  :fuel
      t.references :company,:foreign_ley =>true
      t.timestamps
    end
    
    add_foreign_key(:cars,:brands)
    add_foreign_key(:cars,:models)
    add_foreign_key(:cars,:users,:dependent => :delete)
    
  end
  

  def self.down
    drop_table :cars
  end
end
