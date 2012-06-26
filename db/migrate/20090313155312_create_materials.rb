class CreateMaterials < ActiveRecord::Migration
  def self.up
    create_table :materials do |t|
      t.string :code,:limit => 50
      t.string :prov_code,:limit => 50
      t.string :name
      t.integer :category_id
      t.integer :sub_category_id
      t.timestamps
    end
    
    add_index :materials,:name
    add_index :materials,:code
    add_index :materials,:prov_code

  end

  def self.down
    drop_table :materials
  end
end
