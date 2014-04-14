class PriceListItem < ActiveRecord::Base
  belongs_to :price_list
  belongs_to :material_service_type
  has_one :material, :through => :material_service_type
  has_one :company_material_code, :through => :material_service_type
  def to_s
    "#{id} #{price_list_id} #{material_service_type} #{price}"
  end
  
  def self.all_materials    
    PriceListItem.all :select =>"price_list_items.price_list_id,price_list_items.price,
    mst.service_type_id",:joins =>"right outer join material_service_types as mst on price_list_items.material_service_type_id = mst.id"  
  end

end

