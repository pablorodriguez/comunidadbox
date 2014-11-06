class ServiceType < ActiveRecord::Base  
  attr_accessible :name, :kms, :parent_id, :active,:days,:company_id,:code,:old_id
  default_scope where("active = 1").order("name")
  scope :active, where("active = 1")

  has_many :material_service_type
  has_many :materials ,:through => :material_service_type
  has_many :company_services
  has_many :companies, :through => :company_services
  has_many :events
  has_many :service_filters
  has_many :material_requests
  has_and_belongs_to_many :tasks
  belongs_to :parent, :class_name=>"ServiceType"
  belongs_to :company

  validates_presence_of :name

  def self.to_builder service_types
    Jbuilder.encode do |json|      
      json.array! service_types do |st|           
        json.id st.id
        json.name st.name        
      end
    end
  end

  def self.has_for_company?(company_id)
    ServiceType.where("company_id = ?",company_id).count > 0
  end

  def is_periodic?
    is_kms_periodic? || is_days_periodic?
  end

  def is_kms_periodic?
    self.kms and self.kms > 0
  end

  def is_days_periodic?
    self.days and self.days > 0
  end

  def native_name
    I18n.t(name)
  end

  def to_builder
    Jbuilder.new do |service_type|      
      service_type.(self,:id,:name)      
    end
  end
  
end

