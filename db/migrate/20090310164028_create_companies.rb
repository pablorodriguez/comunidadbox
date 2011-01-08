class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.references :country
      t.references :user
      t.string :phone
      t.string :website
      t.string :cuit  ,:limit=>13
      t.boolean :active
      t.timestamps
    end
    add_foreign_key(:companies,:countries)    
  end

  def self.down
    drop_table :companies
  end
end
