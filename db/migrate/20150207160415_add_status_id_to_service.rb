class AddStatusIdToService < ActiveRecord::Migration
  def change
  	add_column :services, :status_id, :integer

    company = Company.find(7)
  	status_1 = Status.create(name: "Abierto", is_final: false)
  	status_1.id = 1
    status_1.company = company
  	status_1.save!

  	status_2 = Status.create(name: "En Proceso", is_final: false)
  	status_2.id = 2
    status_2.company = company
  	status_2.save!

  	status_4 = Status.create(name: "Finalizado", is_final: true)
  	status_4.id = 4
    status_4.company = company
  	status_4.save!

  	status_7 = Status.create(name: "Confirmado", is_final: false)
  	status_7.id = 7
    status_7.company = company
  	status_7.save!

  	Service.includes("workorder").where("workorders.company_id = 7").find_in_batches do |batch|
  		batch.each do |service|
  			if [1, 2, 4, 7].include? service.status
          service.status_id = service.status
          service.save!
  			end
  		end
  	end
	end
end
