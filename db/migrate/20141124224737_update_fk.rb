class UpdateFk < ActiveRecord::Migration
  def up
    remove_foreign_key(:ranks,:workorders)
    add_foreign_key(:ranks,:workorders,:dependent => :delete)

    remove_foreign_key(:companies_users,:companies)
    add_foreign_key(:companies_users,:companies,:dependent => :delete)


    remove_foreign_key(:company_services,:name =>:company_services_ibfk_1)
    remove_foreign_key(:company_services,:name =>:company_services_ibfk_2)

    execute("delete from company_services where id =6")
    add_foreign_key(:company_services,:companies,:dependent => :delete)
    add_foreign_key(:company_services,:service_types)

    remove_foreign_key(:users,:name =>:users_ibfk_1)
    add_foreign_key(:users,:companies,:column =>:employer_id,:dependent => :delete)

    remove_foreign_key(:workorders,:name =>:workorders_ibfk_1)
    remove_foreign_key(:workorders,:name =>:workorders_ibfk_2)
    remove_foreign_key(:workorders,:name =>:workorders_ibfk_3)
    add_foreign_key(:workorders,:cars)
    add_foreign_key(:workorders,:companies,:dependent => :delete)
    add_foreign_key(:workorders,:users)

    remove_foreign_key(:notes,:companies)
    add_foreign_key(:notes,:companies,:dependent => :delete)

    remove_foreign_key(:service_type_templates,:companies)
    add_foreign_key(:service_type_templates,:companies,:dependent => :delete)

    execute("delete from workorders where company_id=24")
    execute("delete from workorders where company_id=26") 
    execute("delete from companies where id in (13,14,19,21,24,25,26)")

	execute("delete  from workorders where id in (14078,16105)")
	execute("update service_types set company_id = 28 where id in (13,14)")
	execute("delete from material_service_types where service_type_id is null")

    execute("delete  from workorders where id in (14078,16105)")
    execute("update service_types set company_id = 28 where id in (13,14)")

    drop_table :company_services

    execute("insert into service_types (name,kms,parent_id,active,code,created_at,updated_at,days,company_id) select name,kms,null,active,code,created_at,updated_at,days,1 from service_types where company_id =12")

  end

  def down
  end
end
