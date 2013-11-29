class CreatePriceListItems < ActiveRecord::Migration
  def self.up
    create_table :price_list_items do |t|
      t.integer :price_list_id
      t.integer :material_service_type_id
      t.decimal :price,precision: 10, scale: 2
      t.timestamps
    end
    
    add_foreign_key(:price_list_items,:price_lists,:dependent => :delete)
    add_foreign_key(:price_list_items,:material_service_types)
  end

  def self.down
    drop_table :price_list_items
  end
end
