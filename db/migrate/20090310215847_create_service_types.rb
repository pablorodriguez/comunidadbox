
class CreateServiceTypes < ActiveRecord::Migration
  def self.up
    create_table :service_types do |t|
      t.string :name
      t.integer :kms
      t.integer :parent_id
      t.string :active
      t.string :code, :limit => 10
      t.timestamps
    end
  end

  def self.down
    drop_table :service_types
  end
end
