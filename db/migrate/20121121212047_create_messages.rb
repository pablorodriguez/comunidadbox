class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.text :message
      t.boolean :read,:default =>0
      t.references :user
      t.integer :receiver_id
      t.references :event
      t.references :workorder
      t.references :budget
      t.references :message
      t.references :alarm
      t.timestamps
    end

    add_foreign_key(:messages,:users,:dependent => :delete)
    add_foreign_key(:messages,:workorders,:dependent => :delete)
    add_foreign_key(:messages,:budgets,:dependent => :delete)
    add_foreign_key(:messages,:events,:dependent => :delete)
    add_foreign_key(:messages,:alarms,:dependent => :delete)
    add_foreign_key(:messages,:messages,:dependent => :delete)
    
  end

   def self.down
    drop_table :messages
  end

end
