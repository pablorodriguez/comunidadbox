class CompanyService < ActiveRecord::Base
  belongs_to :company
  belongs_to :service_type

  def self.companies(ids)
    CompanyService.includes(:service_type).where("company_id IN (?)",ids).order("service_types.name").group(:service_type_id).map(&:service_type)
  end

  
end
