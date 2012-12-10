class AddCarIdToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :car_id, :integer
    add_foreign_key(:notes,:cars,:dependent => :delete)  
  end
end
