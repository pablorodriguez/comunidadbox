class AddImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :car
      t.references :company      
      t.string :image
      t.timestamps
    end
    add_index :images, :car_id
    add_index :images, :company_id
    add_foreign_key(:images,:cars)
    add_foreign_key(:images,:companies)
  end
end
