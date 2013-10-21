class MaterialRequest < ActiveRecord::Base
	attr_accessible :cod_provider, :description, :provider, :state, :trademark, :message, :service_type_id, :user_id, :company_id
  validates_presence_of :provider, :description, :trademark
  belongs_to :user
  belongs_to :company
  belongs_to :service_type
end
