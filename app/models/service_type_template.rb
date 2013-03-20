class ServiceTypeTemplate < ActiveRecord::Base
  attr_accessible :name,:service_type_id,:material_service_type_templates_attributes

  has_many :material_service_type_templates
  belongs_to :service_type
  belongs_to :company

  accepts_nested_attributes_for :material_service_type_templates,:reject_if => lambda { |m| m[:material].blank? }, :allow_destroy => true

  attr :price

  
end
