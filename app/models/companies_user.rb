# encoding: utf-8
class CompaniesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :company

  def self.users company_ids
  	CompaniesUser.includes(:user).where("company_id in (?)", company_ids).order("users.last_name")
  end
end

