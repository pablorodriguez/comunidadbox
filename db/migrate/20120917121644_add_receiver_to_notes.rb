class AddReceiverToNotes < ActiveRecord::Migration

  def change
    add_column :notes,:receiver_id,:integer
    add_column :notes,:respond_to_id,:integer  
    add_foreign_key(:notes,:users,:column =>:receiver_id,:dependent => :delete)
  end

  
end
