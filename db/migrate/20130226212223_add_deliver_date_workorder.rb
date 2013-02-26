class AddDeliverDateWorkorder < ActiveRecord::Migration
  def change
    add_column :workorders, :deliver, :datetime
    add_column :workorders, :deliver_actual, :datetime
  end

  
end
