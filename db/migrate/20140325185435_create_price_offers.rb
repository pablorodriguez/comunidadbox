class CreatePriceOffers < ActiveRecord::Migration
  def change
    create_table :price_offers do |t|
      t.text :price
      t.references :workorder
      t.references :user
      t.boolean :confirmed,  default: true 

      t.timestamps
    end

    add_index :price_offers, :workorder_id
    add_index :price_offers, :user_id
    add_foreign_key(:price_offers, :workorders)
    add_foreign_key(:price_offers, :users)
  end
end
