class AddCompanyInfoToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :company_name,:string
    add_column :users, :cuit,:string
  end

  def self.down
    remove_column :users,:company_name
    remove_column :users,:cuit
  end
end
