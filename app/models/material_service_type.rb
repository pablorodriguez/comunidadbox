class MaterialServiceType < ActiveRecord::Base
 attr_accessible :material_id, :service_type_id
  belongs_to :material
  belongs_to :service_type
  has_many :price_list_items
  has_one :price_list_item_active, :class_name =>"PriceListItem",
    :include=>"price_list", :conditions =>["price_lists.active =1"]
  
  accepts_nested_attributes_for :material
  accepts_nested_attributes_for :service_type
  
  def self.materials company_id
    MaterialServiceType.includes({:price_list_items_active=>{:price_list=>{}},:service_type=>{:companies=>{}}}).where("companies.id = ? ",company_id)
  end
  
  def self.m(company_id,price_list_id,service_type_ids,material,page)
        
    select_str ="material_service_types.id,material_service_types.material_id,m.code,m.name,material_service_types.service_type_id,st.name,pli.price  "
    
    join_str ="LEFT OUTER JOIN price_list_items as pli ON pli.material_service_type_id = material_service_types.id and pli.price_list_id=#{price_list_id} 
    LEFT OUTER JOIN service_types as st ON st.id = material_service_types.service_type_id"
    
    if (service_type_ids.size > 0)
      join_str += " and material_service_types.service_type_id in (#{service_type_ids.join(",")})"
    end
    
    join_str += " INNER JOIN company_services as cs ON cs.service_type_id = st.id and cs.company_id=#{company_id} LEFT OUTER JOIN materials as m ON material_service_types.material_id = m.id" 
    
    unless material.blank?
    #  join_str += " and m.name LIKE '%#{material}%'"
    end
    
    #join_str +=" ORDER BY st.name,m.code"
    
    #data = MaterialServiceType.find(:all,:select => select_str,:conditions=>['m.name LIKE ?',"%#{material}%"] ,:joins=>join_str)
    
    if (page >=0)  
      return MaterialServiceType.paginate(:per_page=>20,:page =>page,:select => select_str,:conditions=>['m.name LIKE ?',"%#{material}%"] ,:joins=>join_str,:order =>"st.name,m.name")  
    else
      return MaterialServiceType.find(:all,:select => select_str,:conditions=>['m.name LIKE ?',"%#{material}%"] ,:joins=>join_str)
    end
  end
  
  
end


