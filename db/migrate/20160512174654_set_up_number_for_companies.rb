class SetUpNumberForCompanies < ActiveRecord::Migration
  def up
    Company.where("id > ?",1).each do |company|
      user = company.user
      user.companies.first.update_attribute("headquarter",1) if user.companies.size == 1        
    end

    Company.all.each do |company|
      CompanyAttribute.create({"company_id" => company.id})
    end

  end

  def down
    CompanyAttribute.delete_all
  end
end
