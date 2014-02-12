class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.integer :service_offer_id

      t.timestamps
    end
  end
end
