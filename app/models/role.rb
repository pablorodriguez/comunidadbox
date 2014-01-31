class Role < ActiveRecord::Base
  has_many :users
  ADMINISTRATOR = 'administrator'
  EMPLOYEE ='employee'
  SUPER_ADMIN ='super_admin'
  OPERATOR ='operator'
  MANAGER='manager'

  def self.employee_roles
    Role.where("name IN (?)",[OPERATOR,ADMINISTRATOR,EMPLOYEE]).order("detail")
  end
  
  
  def self.administrator
    Role.find_by_name(ADMINISTRATOR)
  end
  
  def self.employee
    Role.find_by_name(EMPLOYEE)
  end
end
