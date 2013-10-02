class MaterialRequest < ActiveRecord::Base
 attr_accessible :cod_provider, :description, :provider, :state, :trademark, :service_type_id

  belongs_to :user
  belongs_to :company
  belongs_to :service_type
end
