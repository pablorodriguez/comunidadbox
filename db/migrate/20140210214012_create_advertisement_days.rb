class CreateAdvertisementDays < ActiveRecord::Migration
  def change
    create_table :advertisement_days do |t|
      t.date :published_on
      t.integer :advertisement_id

      t.timestamps
    end
    add_foreign_key(:advertisement_days,:advertisements,:dependent => :delete)
  end
end
