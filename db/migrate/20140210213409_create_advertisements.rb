class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.integer :service_offer_id
      t.timestamps
    end
    add_foreign_key(:advertisements,:service_offers,:dependent => :delete)
  end
end
