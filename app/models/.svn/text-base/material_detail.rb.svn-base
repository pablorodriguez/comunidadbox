class MaterialDetail < ActiveRecord::Base
  
  attr :amount,true
  attr :id,true
  attr :row,true
  
  attr :task_ids,true
  attr :comment,true
  attr :per_page , true
#  attr :service_type_id,true
  
  def totalPrice
    amount * price
  end
end
