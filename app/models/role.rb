class Role < ActiveRecord::Base
  has_many :users
  ADMINISTRATOR = 'administrator'
  EMPLOYEE ='employee'
  SUPER_ADMIN ='super_admin'
  OPERATOR ='operator'
  MANAGER='manager'
  
  
  def self.administrator
    Role.find_by_name(ADMINISTRATOR)
  end
  
  def self.employee
    Role.find_by_name(EMPLOYEE)
  end
end
