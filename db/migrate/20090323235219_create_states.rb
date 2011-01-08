class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.references :country
      t.string :short_name
      t.string :name
      t.timestamps
    end
    add_foreign_key(:states,:countries,:dependent => :delete)
  end

  def self.down
    drop_table :states
  end
end
