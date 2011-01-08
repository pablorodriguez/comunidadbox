class CreateUserRoles < ActiveRecord::Migration
  def self.up
    create_table :user_roles do |t|
      t.references :user
      t.references :role
      t.references :company
      t.timestamps
    end
    
    add_foreign_key(:user_roles,:users,:dependent => :delete)
    add_foreign_key(:user_roles,:roles,:dependent => :delete)
  end

  def self.down
    drop_table :user_roles
  end
end
