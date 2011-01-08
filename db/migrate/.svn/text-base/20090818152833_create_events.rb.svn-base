class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.references :car
      t.references :service_type
      t.references :service
      t.string :status
      t.date :dueDate

      t.timestamps
    end
    add_foreign_key(:events,:services,:dependent => :delete)
  end

  def self.down
    drop_table :events
  end
end
