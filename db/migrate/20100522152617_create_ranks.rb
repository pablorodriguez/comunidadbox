class CreateRanks < ActiveRecord::Migration
  def self.up
    create_table :ranks do |t|
      t.text :comment
      t.string :type,:limit => 10
      t.integer :cal
      t.timestamps
    end
  end

  def self.down
    drop_table :ranks
  end
end
