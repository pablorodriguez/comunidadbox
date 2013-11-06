class ItemServiceRequest < ActiveRecord::Base
  attr_accessible :date_from, :date_to, :description, :price, :service_request_id, :service_type_id

  belongs_to :service_request
  belongs_to :service_type
end
