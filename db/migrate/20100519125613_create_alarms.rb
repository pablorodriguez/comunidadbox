class CreateAlarms < ActiveRecord::Migration
  def self.up
    create_table :alarms do |t|
      t.string :name
      t.text :description
      t.integer :time
      t.string :time_unit
      t.integer :status,:limit => 2
      t.datetime :date_ini
      t.datetime :date_end
      t.datetime :date_alarm
      t.references :user

      t.timestamps
    end
    
    add_foreign_key(:alarms,:users,:dependent => :delete)
  end

  def self.down
    drop_table :alarms
  end
end

