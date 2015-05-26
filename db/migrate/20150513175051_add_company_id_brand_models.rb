class AddCompanyIdBrandModels < ActiveRecord::Migration
  def change
    add_column :brands, :company_id, :integer
    #add_column :models, :company_id, :integer

    execute "delete from brands where name is null"
    
    #Set Combox company id for all brands
    execute "update brands set company_id = 12 , of_cars = 1"
    #execute "update models set company_id = 12"

    #Set Pyerredon Motos id fro those brands id"
    execute "update brands set company_id = 28, of_motorcycles = 1, of_cars = 0 where id IN (124,125,126,127,128,129)"
    #execute "update models set company_id = 28 where brand_id IN (124,125,126,127,128,129)"
    
  end

end
