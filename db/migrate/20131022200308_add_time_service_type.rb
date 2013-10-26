class AddTimeServiceType < ActiveRecord::Migration
  def change
  	add_column :service_types, :days, :integer
  end
  
end
