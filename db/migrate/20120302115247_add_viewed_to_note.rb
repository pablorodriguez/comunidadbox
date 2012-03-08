class AddViewedToNote < ActiveRecord::Migration
  def self.up
  	add_column :notes, :viewed, :boolean
  	change_column(:notes, :status, :string,:limit =>50)
  end

  def self.down
  	remove_column :notes, :viewed
  	change_column(:notes, :status, :integer)
  end
end
