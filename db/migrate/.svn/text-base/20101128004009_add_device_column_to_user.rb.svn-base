class AddDeviceColumnToUser < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      #t.remove :remember_token,:remember_token_expires_at,:created_at,:updated_at
      #t.rename :email,:email2
      t.remove :email,:created_at,:updated_at
      #t.remove :email,:created_at,:updated_at,:encrypted_password
      t.remove 
      t.database_authenticatable :null => false
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable
      #t.lockable
      t.timestamps
    end
    
    #add_index :users, :email,                :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :reset_password_token, :unique => true
    #add_index :users, :unlock_token,         :unique => true
    #execute "update users set email = email2"
    #execute "update users set encrypted_password = crypted_password, password_salt = salt "
    #remove_column :users, :email2
    #remove_column :users, :crypted_password
    #remove_column :users, :salt
  end
  
  def self.down
    drop_table :users
  end
end
