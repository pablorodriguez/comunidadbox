class MaterialDetail < ActiveRecord::Base
  
  attr :amount,true
  attr :id,true
  attr :row,true
  
  attr :task_ids,true
  attr :comment,true
  attr :per_page , true
  attr :page,true
#  attr :service_type_id,true
  
  def totalPrice
    amount * price
  end
  
  def self.search(company_id,service_type_id,detail)
    MaterialDetail.where('detail_upper LIKE ? and service_type_id = ? and company_id = ?',"%#{detail}%",service_type_id,company_id)
  end
    
  
  
end
