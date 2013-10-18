class AddCarServiceOfferToServices < ActiveRecord::Migration
  def change
    add_column :services, :car_service_offer_id, :integer
    add_foreign_key(:services,:car_service_offers)
  end
end
