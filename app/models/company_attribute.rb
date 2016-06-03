class CompanyAttribute < ActiveRecord::Base
  attr_accessible :company_id, :material_control,:budget_nro,:work_order_nro
  belongs_to :company

  BUDGET_NUMBER ="BUDGET_NUMBER"
  WORKORDER_NUMBER = "WORKORDER_NUMBER"
  CONTROL_MATERIALS = "CONTROL_MATERIALS"

  before_save :set_default_data

  def set_default_data
    self.work_order_nro = Workorder.get_last_number(self.company_id) unless self.work_order_nro
    self.budget_nro = Budget.get_last_number(self.company_id) unless self.budget_nro
  end

  after_initialize do |company_attribute|
    company_attribute.set_default_data
  end

  # Get Company Attribute for company_id or for its headquarter
  def self.get_attributes_for company_id
    CompanyAttribute.where("company_id = ?", company_id).first
  end

  def self.generate_workorder_number company_id
    generate_number company_id, "work_order_nro"
  end

  def self.generate_budget_number company_id
    generate_number company_id, "budget_nro"
  end

  def self.generate_number company_id, prop_name
    company_attributes = CompanyAttribute.get_attributes_for(company_id)
    company_attributes.with_lock do
      current_value = company_attributes.send(prop_name)
      current_value = 0 unless current_value
      company_attributes.send("#{prop_name}=", (current_value + 1))
      company_attributes.save
    end
    return company_attributes.send(prop_name)
  end

  def self.get_last_number company_id,attribute
    comp_attr =  CompanyAttribute.get_attributes_for(company_id)
    last_number = comp_attr.send(attribute) || 0
    last_number
  end

  def self.get_last_budget_number company_id
    self.get_last_number company_id,"budget_nro"
  end

  def self.get_last_work_order_number company_id
    self.get_last_number company_id,"work_order_nro"
  end

  def self.set_update_last_number company_id, attribute,value

  end

  def self.reset_numbers company_id
    reset_budget_numbers company_id
    reset_workorder_numbers company_id
  end

  def self.reset_budget_numbers company_id
    comp_attribute = CompanyAttribute.get_attributes_for(company_id).lock!
    last_budget_number = Budget.get_last_number company_id
    comp_attribute.budget_nro = last_budget_number +1
    comp_attribute.save
  end

   def self.reset_workorder_numbers company_id
    comp_attribute = CompanyAttribute.get_attributes_for(company_id).lock!
    last_workorder_number = Workorder.get_last_number company_id
    comp_attribute.work_order_nro = last_workorder_number + 1
    comp_attribute.save
  end




end
