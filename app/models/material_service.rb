class MaterialService < ActiveRecord::Base
  attr_accessible :material_service_type_id, :material, :amount, :price
  
  belongs_to :service
  belongs_to :material_service_type
  
  validates_numericality_of :price, :greater_than_or_equal_to => 0.01
  validates_numericality_of :amount, :only_integer => true, :greater_than_or_equal_to => 1   
   
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
  
end
