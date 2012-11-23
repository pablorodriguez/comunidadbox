class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.text :message
      t.datetime :due_date
      t.datetime :recall
      t.datetime :start_date
      t.datetime :end_date
      t.integer :status
      t.integer :creator_id
      t.references :user
      t.references :workorder
      t.references :note
      t.timestamps
    end
    
    add_foreign_key(:notes,:users,:dependent => :delete)
    add_foreign_key(:notes,:workorders,:dependent => :delete)
    add_foreign_key(:notes,:notes,:column =>:note_id,:dependent => :delete)
    add_foreign_key(:notes,:users,:column =>:creator_id,:dependent => :delete)
  end

  def self.down
    drop_table :notes
  end
end
