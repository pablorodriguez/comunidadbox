class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.string  :comment
      t.references :workorder
      t.references :service_offer
      t.references :service_type
      t.string :material,:limit =>250
      t.integer :status,:limit => 2
      t.timestamps
    end
    add_foreign_key(:services,:workorders,:dependent => :delete)
    add_foreign_key(:services,:service_types)
  end

  def self.down
    drop_table :services
  end
end
