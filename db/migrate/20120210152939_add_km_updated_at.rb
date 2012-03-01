class AddKmUpdatedAt < ActiveRecord::Migration
  def self.up
	add_column :cars, :kmUpdatedAt, :datetime
  end

  def self.down
  	remove_column :cars, :kmUpdatedAt
  end
end
