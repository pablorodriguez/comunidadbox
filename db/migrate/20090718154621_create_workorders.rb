class CreateWorkorders < ActiveRecord::Migration
  def self.up
    create_table :workorders do |t|
      t.text :comment
      t.references :company
      t.references :car
      t.references :user
      t.integer :status,:limit => 2
      t.timestamps
    end
    add_foreign_key(:workorders,:cars)
    add_foreign_key(:workorders,:companies)
    add_foreign_key(:workorders,:users)

  end
  
  
  def self.down
    drop_table :workorders
  end
end
