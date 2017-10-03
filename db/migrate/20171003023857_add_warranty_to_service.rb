class AddWarrantyToService < ActiveRecord::Migration
  def change
    add_column :services, :warranty, :boolean
  end
end
