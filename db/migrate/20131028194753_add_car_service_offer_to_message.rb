class AddCarServiceOfferToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :car_service_offer_id, :integer
    add_foreign_key(:messages,:car_service_offers)
  end
end
