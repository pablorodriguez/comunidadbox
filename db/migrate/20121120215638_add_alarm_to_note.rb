class AddAlarmToNote < ActiveRecord::Migration
  def change
    add_column :notes,:alarm_id,:integer
  end
end
