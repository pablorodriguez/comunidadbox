class OfferServiceType < ActiveRecord::Base
  attr_accessible :service_type,:service_type_id,:service_offer_id
  belongs_to :service_type
  belongs_to :service_offer
end
