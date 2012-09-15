class AddDaysToAlarms < ActiveRecord::Migration

  def self.up
    add_column :alarms, :monday,:boolean,:default => false
    add_column :alarms, :tuesday,:boolean,:default => false
    add_column :alarms, :wednesday,:boolean,:default => false
    add_column :alarms, :thursday,:boolean,:default => false
    add_column :alarms, :friday,:boolean,:default => false
    add_column :alarms, :saturday,:boolean,:default => false
    add_column :alarms, :sunday,:boolean,:default => false
    add_column :alarms, :no_end,:boolean,:default => false
    add_column :alarms, :next_time, :timestamp 
    add_column :alarms, :last_time, :timestamp
  end

  def self.down
    remove_column :alarms,:monday
    remove_column :alarms,:tuesday
    remove_column :alarms,:wednesday
    remove_column :alarms,:thursday
    remove_column :alarms,:friday
    remove_column :alarms,:saturday
    remove_column :alarms,:sunday
    remove_column :alarms,:no_end
    remove_column :alarms,:next_time
    remove_column :alarms,:last_time

  end

end
