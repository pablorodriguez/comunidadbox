class MaterialServiceTypeTemplate < ActiveRecord::Base
  attr_accessible :material_service_type, :amount,:name,:material_service_type_id,:material
  belongs_to :service_type_template

  has_one :material_detail, :class_name => 'MaterialDetail',:primary_key => 'material_service_type_id' ,:foreign_key => 'material_service_type_id'

  def price
    id = service_type_template.company.price_list_active.id
    MaterialDetail.select("price").where("material_service_type_id = ? and price_list_id = ?",material_service_type_id,id).first.price
  end

end
