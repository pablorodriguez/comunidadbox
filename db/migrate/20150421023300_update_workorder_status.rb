class UpdateWorkorderStatus < ActiveRecord::Migration
  def change
    #Workorder.where("status_id != 18 or status_id is null").where("performed <= '2015-03-31'")
    total = 0
    total_record = Workorder.where("(status_id = 16 or status_id is null) and created_at <= ? and company_id IN(3,6,7,12,27)",'2015-03-31').count
    p "###### Total Record to updates #{total_record} Lote A"

    Workorder.where("(status_id = 16 or status_id is null) and created_at <= ? and company_id IN(3,6,7,12,27)",'2015-03-31').order("created_at ASC").find_in_batches do |batch|
      batch.each do |workorder|
        workorder.services.each{|service| service.status_id = 18}
        workorder.save
        total+=1
      end
      p "###### Total in batch #{total} Lote A"
    end

  end
end
