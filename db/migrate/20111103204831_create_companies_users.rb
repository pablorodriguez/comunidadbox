class CreateCompaniesUsers < ActiveRecord::Migration
  def self.up
    create_table :companies_users do |t|
      t.references :user, :null => false
      t.references :company, :null => false

      t.timestamps
    end

    Company.update_customer
    add_foreign_key(:companies_users,:users,:dependent => :delete)
    add_foreign_key(:companies_users,:company,:dependent => :delete)
  end

  def self.down
    drop_table :companies_users
  end
end
