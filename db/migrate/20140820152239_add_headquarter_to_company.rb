class AddHeadquarterToCompany < ActiveRecord::Migration
  def change
  	add_column :companies, :headquarter, :boolean
  end
end
