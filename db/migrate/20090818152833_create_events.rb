class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.references :car
      t.references :service_type
      t.references :service
      t.integer :service_done_id
      t.integer :status,:limit => 2
      t.integer :km
      t.date :dueDate
      t.timestamps
    end
    add_foreign_key(:events,:services,:column => :service_id,:dependent => :delete)
    add_foreign_key(:events,:services,:column => :service_done_id,:dependent => :delete)
  end

  def self.down
    drop_table :events
  end
end
