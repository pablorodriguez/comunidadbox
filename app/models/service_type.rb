class ServiceType < ActiveRecord::Base  
  attr_accessible :name, :kms, :parent_id, :active,:days
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

  validates_presence_of :name
  validates_uniqueness_of :name  


  def self.to_builder service_types
    Jbuilder.encode do |json|      
      json.array! service_types do |st|           
        json.id st.id
        json.name st.native_name        
      end
    end
  end

  def native_name
    I18n.t(name)
  end

  def to_builder
    Jbuilder.new do |service_type|      
      service_type.(self,:id,:native_name)      
    end
  end
  
end

