class UpgradeDeviseTo2 < ActiveRecord::Migration
  def change
    ## Recoverable
    #add_column :users,:reset_password_token,:string
    add_column :users,:reset_password_sent_at,:datetime
       
    # t.string   :unconfirmed_email # Only if using reconfirmable
    add_column :users,:unconfirmed_email,:string
  
    ## Lockable
    add_column :users,:failed_attempts,:integer,:default=>0
    # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
    add_column :users,:unlock_token,:string
    # t.string   :unlock_token # Only if unlock strategy is :email or :both
    add_column :users,:locked_at,:datetime
    # t.datetime :locked_at

    # Token authenticatable
    add_column :users,:authenticatable,:string
    # t.string :authentication_token

    ## Invitable
    add_column :users,:invitation_token,:string
    # t.string :invitation_token
  end

  
end
