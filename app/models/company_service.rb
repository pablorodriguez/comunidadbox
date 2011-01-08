class CompanyService < ActiveRecord::Base
  belongs_to :company
  belongs_to :service_type
end
