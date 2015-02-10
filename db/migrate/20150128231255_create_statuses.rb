class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.string :name
      t.boolean :is_final
      t.references :company

      t.timestamps
    end
    add_foreign_key(:statuses,:companies)
  end

  def self.down
    drop_table :statuses
  end
end
