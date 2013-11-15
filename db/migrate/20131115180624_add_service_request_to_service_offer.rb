class AddServiceRequestToServiceOffer < ActiveRecord::Migration
  def change
    add_column :service_offers, :service_request_id, :integer
    add_foreign_key(:service_offers,:service_requests,:dependent => :delete)  
  end
end
