class AddStatusIdToServiceAndWorkorder < ActiveRecord::Migration
  def change
    add_column :services, :status_id, :integer
    add_column :workorders, :status_id, :integer

    #Creo los estados para todas las empresas
    Company.joins(:user).each do |c|
        ids = c.user.companies.map(&:id).join(",")
        s = Status.create(company_id: c.id, name: "Abierto", is_final: false)   
        execute "update workorders set status_id = #{s.id} where status = 1 and company_id in (#{ids})"
        execute "update services s inner join workorders w on s.workorder_id = w.id set s.status_id = #{s.id}  where s.status = 1 and w.company_id in (#{ids})"

        s = Status.create(company_id: c.id, name: "En Progreso", is_final: false)    
        execute "update workorders set status_id = #{s.id} where status = 2 and company_id in (#{ids})"
        execute "update services s inner join workorders w on s.workorder_id = w.id set s.status_id = #{s.id}  where s.status = 2 and w.company_id in (#{ids})"

        s = Status.create(company_id: c.id, name: "Finalizado", is_final: true)   
        execute "update workorders set status_id = #{s.id} where status = 4 and company_id in (#{ids})"
        execute "update services s inner join workorders w on s.workorder_id = w.id set s.status_id = #{s.id}  where s.status = 4 and w.company_id in (#{ids})"
 
    end
  end
end
