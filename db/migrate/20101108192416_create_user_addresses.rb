class CreateUserAddresses < ActiveRecord::Migration
  def self.up
    create_table :user_addresses do |t|
      t.integer :user_id
      t.integer :address_id
      t.string  :type

      t.timestamps
    end
  end

  def self.down
    drop_table :user_addresses
  end
end
