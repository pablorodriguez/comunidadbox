class AddEventToNote < ActiveRecord::Migration
  def self.up
  	add_column :notes, :event_id, :integer
  end

  def self.down
  	remove_column :notes, :event_id
  end
end
