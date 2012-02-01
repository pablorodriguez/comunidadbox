class AddDetailsToMaterials < ActiveRecord::Migration
  def self.up
  	add_column :materials, :brand, :string
  	add_column :materials, :provider, :string
  end

  def self.down
  	remove_column :materials, :brand
  	remove_column :materials, :provider
  end
end
