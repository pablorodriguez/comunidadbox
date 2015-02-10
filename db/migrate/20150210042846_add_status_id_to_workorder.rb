class AddStatusIdToWorkorder < ActiveRecord::Migration
  def change
  	add_column :workorders, :status_id, :integer

  	Workorder.where(company_id: 7).find_in_batches do |batch|
  		batch.each do |workorder|
  			if [1, 4].include? workorder.status
          workorder.update_column(:status_id, workorder.status)
  			end
  		end
  	end
  end
end
