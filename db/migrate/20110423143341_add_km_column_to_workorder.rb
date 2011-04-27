class AddKmColumnToWorkorder < ActiveRecord::Migration
  def self.up
     add_column :workorders, :km,:integer
  end

  def self.down
    remove_column :workorders,:km
  end
end
