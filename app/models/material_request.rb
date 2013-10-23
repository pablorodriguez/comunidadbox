class MaterialRequest < ActiveRecord::Base
  attr_accessible :cod_provider, :description, :provider, :status, :trademark, :message, :service_type_id, :user_id, :company_id, :details
  include Statused  

  validates_presence_of :provider, :description, :trademark, :service_type_id, :details

  belongs_to :user
  belongs_to :company
  belongs_to :service_type
  belongs_to :material

  default_scope {order("material_requests.created_at DESC")}
  after_initialize :init
  before_save :to_before_save

  def to_before_save
    if change_to_approved?
        generate_new_material
    end
  end

  def change_to_approved?
    ((self.status_was != Status::APPROVED ) && (self.status == Status::APPROVED)) ? true : false
  end

  def self.generate_new_code
    material_code = Material.where("code like ?","NM%").last
    if material_code.nil?
      "NM00000"
    else
      material_code.code.succ
    end
  end

  #creo el material a partir de un material request
  def generate_new_material 
    new_code = MaterialRequest.generate_new_code    
    material = create_material(code: new_code,prov_code: new_code,provider: self.provider, name: self.description)
    material.material_service_type.create(service_type_id: self.service_type_id)
    material
  end
    
  private
    def init
      self.status = Status::OPEN unless self.status
      
    end
end


