class CreateOfferServiceTypes < ActiveRecord::Migration
  def change
    create_table :offer_service_types do |t|
      t.integer :service_offer_id
      t.integer :service_type_id
      t.timestamps
    end
    ServiceOffer.destroy_all
    #remove_column :service_offers,:service_type_id
    add_foreign_key(:offer_service_types,:service_offers)
    add_foreign_key(:offer_service_types,:service_types)
  end
end
