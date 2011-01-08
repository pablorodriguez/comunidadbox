class Material < ActiveRecord::Base
  has_many :material_service_type
  has_many :service_types, :through => :material_service_type
 
  validates_presence_of :code, :name
  validates_uniqueness_of :code,:prov_code
  validates_format_of :code, :with => /^\D{2}\d{5}/
  
  belongs_to :category
  belongs_to :sub_category,:class_name => 'Category', :foreign_key => 'sub_category_id'
  
  def Material.all_materials(price_list)
    comp_id = price_list.company_id
    comp_service_type = CompanyService.all(:conditions=>["company_id = ?",comp_id])
    service_types_ids = comp_service_type.map{|x| x.service_type_id}
    all_materials = MaterialService.all(:conditions=>["material_service_types.service_type_id in (?)",service_types_ids],
        :include=>{:material_service_type =>{:service_type=>{}}})
    all_materials
  end
  
  def detail
    "[#{code}] #{name}"
  end
end
