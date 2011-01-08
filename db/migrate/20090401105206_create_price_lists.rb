class CreatePriceLists < ActiveRecord::Migration
  def self.up
    create_table :price_lists do |t|
      t.string :name
      t.boolean :active
      t.integer :company_id

      t.timestamps
    end
    
    
  end

  def self.down
    drop_table :price_lists
  end
end
