class CreateAdvertisementDays < ActiveRecord::Migration
  def change
    create_table :advertisement_days do |t|
      t.date :published_on
      t.integer :advertisement_id

      t.timestamps
    end
  end
end
