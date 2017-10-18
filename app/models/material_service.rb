class MaterialService < ActiveRecord::Base
  acts_as_paranoid

  attr_accessible :material_service_type_id, :material, :amount, :price

  belongs_to :service,:inverse_of => :material_services
  belongs_to :material_service_type

  validates_numericality_of :price
  validates_numericality_of :amount, :only_integer => true

  accepts_nested_attributes_for :material_service_type

  #validate :validate_number

  def validate_number
    if amount <= 0
      errors.add(:Cantidad,'debe ser mayor a 0')
    end

    #if price <= 0
    #  errors.add(:Precio,'debe ser mayor a 0')
    #end
  end

  def is_protected?
    material_service_type && material_service_type.protected?
  end

  def total_protected_price
    is_protected? ? total_price : 0
  end

  def total_price
    amount * price
  end

  def material_no_code
    material.gsub(/\[\d+\]/,'').lstrip
  end

  def detail
    if self.material_service_type
      m = material_service_type.material
      "[#{m.code}] #{m.name} $ #{price}"
    else
      ""
    end
  end

  def material_detail
    det = self.detail
    det = self.material if det.blank?

    det.to_s
  end

  def material_code
    if self.material_service_type
      m = material_service_type.material
      "#{m.code}"
    else
      ""
    end
  end
  def material_prov_code
    if self.material_service_type
      m = material_service_type.material
      "#{m.prov_code}"
    else
      ""
    end
  end
  def material_name
    if self.material_service_type
      m = material_service_type.material
      "#{m.name}"
    else
      "#{material}"
    end
  end
end
