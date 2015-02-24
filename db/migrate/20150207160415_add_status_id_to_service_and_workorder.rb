class AddStatusIdToServiceAndWorkorder < ActiveRecord::Migration
  def change
    add_column :services, :status_id, :integer
    add_column :workorders, :status_id, :integer

    Status.create(id: 1, company_id: 7, name: "Abierto", is_final: false)   
    Status.create(id: 2, company_id: 7, name: "En Proceso", is_final: false)    
    Status.create(id: 4, company_id: 7, name: "Finalizado", is_final: true)   
    Status.create(id: 7, company_id: 7, name: "Confirmado", is_final: false)
    
    execute "update services s inner join workorders w on s.workorder_id = w.id set s.status_id = s.status  where w.company_id in (3,6,7,12,27)"
    execute "update workorders set status_id = status  where company_id in (3,6,7,12,27)"
    
  end
end
