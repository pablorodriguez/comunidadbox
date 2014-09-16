class Material < ActiveRecord::Base
  attr_accessible :prov_code, :code, :name, :brand, :provider

  has_many :material_service_type
  has_many :service_types, :through => :material_service_type
 
  validates_presence_of :code, :name
  validates_uniqueness_of :code,:prov_code
  validates_format_of :code, :with => /^\D{2}\d{5}/
  
  belongs_to :category
  belongs_to :sub_category,:class_name => 'Category', :foreign_key => 'sub_category_id'
  
  def Material.all_materials(price_list)
    comp_id = price_list.company_id
    comp_service_type = CompanyService.where("company_id = ?",comp_id)
    service_types_ids = comp_service_type.map{|x| x.service_type_id}
    all_materials = MaterialService.where("material_service_types.service_type_id in (?)",service_types_ids,
        :include=>{:material_service_type =>{:service_type=>{}}})
    all_materials
  end
  
  def detail
    "#{name} #{brand}"    
  end

  def self.find_by_params params
    params.delete_if {|k,v| v.empty?}

    page = params[:page] || 1

    material = Material.order(:name)
    material = material.where("code LIKE ?","%#{params[:code]}%") if params[:code]
    material = material.where("name LIKE ?","%#{params[:name]}%") if params[:name]
    material = material.where("brand LIKE ?","%#{params[:brand]}%") if params[:brand]
    material = material.where("provider LIKE ?","%#{params[:provider]}%") if params[:provider]
    
    if params[:service_type_ids]
      material = material.includes(:material_service_type).where("material_service_types.service_type_id IN (?)",params[:service_type_ids]) 
    end

    material = material.paginate(:per_page => 50, :page => page, :order=>'name')
    material
  end

  
  def self.create_material(prov_code,code,name,brand,provider)
    # creo el material
    m = Material.new
    m.prov_code = prov_code
    m.code = code
    m.name = name
    m.brand = brand
    m.provider = privider
    m.save
    m
  end
end
