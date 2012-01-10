class CompanyService < ActiveRecord::Base
  belongs_to :company
  belongs_to :service_type

  def self.companies ids
    CompanyService.where("company_id IN (?)",ids).group(:service_type_id).map(&:service_type)
  end

  
end
