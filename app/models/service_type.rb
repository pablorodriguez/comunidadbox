class ServiceType < ActiveRecord::Base
  attr_accessible :name, :kms, :parent_id, :active
  default_scope :order => "name"

  has_many :material_service_type
  has_many :materials ,:through => :material_service_type
  has_many :company_services
  has_many :companies, :through => :company_services
  has_many :events
  has_many :service_filters
  has_many :material_requests
  has_and_belongs_to_many :tasks
  belongs_to :parent, :class_name=>"ServiceType"

  validates_presence_of :name,:kms
  validates_uniqueness_of :name
  validates_numericality_of :kms
  
end

