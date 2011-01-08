class CreateModels < ActiveRecord::Migration
  def self.up
    create_table :models do |t|
      t.string :name
      t.integer :brand_id
      t.timestamps
    end    
    add_foreign_key(:models,:brands)
    
    
  end

  def self.down
    drop_table :models
  end
end
