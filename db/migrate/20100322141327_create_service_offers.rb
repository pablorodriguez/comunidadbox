class CreateServiceOffers < ActiveRecord::Migration
  def self.up
    create_table :service_offers do |t|
      t.float :price
      t.float :final_price
      t.float :discount
      t.float :percent
      t.string :status
      t.date :since
      t.date :until
      t.boolean :monday, :default => false
      t.boolean :tuesday, :default => false
      t.boolean :wednesday, :default => false
      t.boolean :thursday, :default => false
      t.boolean :friday, :default => false
      t.boolean :saturday, :default => false
      t.boolean :sunday, :default => false
      t.text :comment
      t.references :service_type
      t.references :company
      t.date :send_at
      t.string :title

      t.timestamps
    end
    add_foreign_key(:service_offers,:companies)
    add_foreign_key(:service_offers,:service_types)
    
  end

  def self.down
    drop_table :service_offers
  end
end

