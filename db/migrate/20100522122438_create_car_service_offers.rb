class CreateCarServiceOffers < ActiveRecord::Migration
  def self.up
    create_table :car_service_offers do |t|
      t.references :car
      t.references :service_offer
      t.string  :status
      t.timestamps
    end
    
    add_foreign_key(:car_service_offers,:cars,:dependent => :delete)
    add_foreign_key(:car_service_offers,:service_offers,:dependent => :delete)
    
  end

  def self.down
    drop_table :car_service_offers
  end
end
