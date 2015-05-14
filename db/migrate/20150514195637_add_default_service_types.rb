class AddDefaultServiceTypes < ActiveRecord::Migration
  def change
    execute "insert into service_types(name,kms,active,code,days,company_id) select name,kms,active,code,days,1 from service_types where company_id in (12,28)"
    #execute "insert into brands(name,of_cars,of_motorcycles,company_id) select name,of_cars,of_motorcycles,12 from brands where company_id=1"
  end

end
