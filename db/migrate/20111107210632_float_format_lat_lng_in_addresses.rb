class FloatFormatLatLngInAddresses < ActiveRecord::Migration
  def self.up
   change_column :addresses, :lat, :string
   change_column :addresses, :lng, :string
   Address.all.each{|a| a.save}
  end

  def self.down
   change_column :addresses, :lat, :decimal,:precision =>14
   change_column :addresses, :lng, :decimal,:precision =>14
  end
end

