class AddDefaultServiceTypes < ActiveRecord::Migration
  def change
    execute "insert into service_types(name,kms,active,code,days,company_id) select name,kms,active,code,days,1 from service_types where company_id in (12,28)"
  end

end
