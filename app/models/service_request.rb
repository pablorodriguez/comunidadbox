class ServiceRequest < ActiveRecord::Base
  attr_accessible :car_id, :company_id, :status, :user_id

  has_many :item_service_requests

  accepts_nested_attributes_for :item_service_requests,:reject_if => lambda { |m| m[:service_type_id].blank? }, :allow_destroy => true

  
end
