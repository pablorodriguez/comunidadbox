class AddDeviceColumnToUser < ActiveRecord::Migration
  def self.up
    
 ## Recoverable
      add_column :users, :reset_password_token, :string
      #add_column :users, :reset_password_sent_at, :datetime
      add_column :users, :confirmation_token, :string

      ## Rememberable
      #add_column :remember_created_at, :datetime

      ## Trackable
      add_column  :users, :sign_in_count, :integer, :default => 0 
      add_column  :users, :current_sign_in_at, :datetime
      add_column  :users, :last_sign_in_at, :datetime
      add_column  :users, :current_sign_in_ip, :string
      add_column  :users, :last_sign_in_ip, :string

      ## Confirmable
      add_column :users, :encrypted_password, :string
      add_column :users, :confirmed_at, :string
      #add_column :users, :confirmation_sent_at, :datetime
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Token authenticatable
      add_column :users, :authentication_token, :string

      add_index :users, :email,                :unique => true
      add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true

  end

  #def self.up
   # change_table(:users) do |t|
      #t.remove :remember_token,:remember_token_expires_at,:created_at,:updated_at
      #t.rename :email,:email2
      #t.remove :email,:created_at,:updated_at
      #t.remove :email,:created_at,:updated_at,:encrypted_password
      #t.remove 
     #t.database_authenticatable :null => false
      #t.confirmable
      #t.recoverable
      #t.rememberable
      #t.trackable
      #t.lockable
      #t.timestamps
    #end
    
    #add_index :users, :email,                :unique => true
    #add_index :users, :confirmation_token,   :unique => true
    #add_index :users, :reset_password_token, :unique => true
    #add_index :users, :unlock_token,         :unique => true
    #execute "update users set email = email2"
    #execute "update users set encrypted_password = crypted_password, password_salt = salt "
    #remove_column :users, :email2
    #remove_column :users, :crypted_password
    #remove_column :users, :salt
  #end
  
  def self.down
    drop_table :users
  end
end
