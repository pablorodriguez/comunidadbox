include ActionView::Helpers::NumberHelper

class MaterialDetail < ActiveRecord::Base
  
  attr :amount,true
  attr :id,true
  attr :row,true
  
  attr :task_ids,true
  attr :comment,true
  attr :per_page , true
  attr :page,true
#  attr :service_type_id,true

  def price_fmt
    number_to_currency(self.price)
  end
  
  def totalPrice
    amount * price
  end
  
  def self.search(company_id,service_type_id,detail)
    detail.gsub!(" ","%")
    MaterialDetail.where('detail_upper LIKE ? and service_type_id = ? and company_id = ?',"%#{detail}%",service_type_id,company_id)
  end  
  
end
