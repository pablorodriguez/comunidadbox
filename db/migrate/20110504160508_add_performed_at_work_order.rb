class AddPerformedAtWorkOrder < ActiveRecord::Migration
  def self.up
     add_column :workorders, :performed,:date
  end

  def self.down
     remove_column :workorders,:performed
  end
end
