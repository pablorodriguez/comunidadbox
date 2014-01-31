class EmployeeSearch < NoTableModel::Base
  attributes :first_name,:last_name,:email,:roles,:status

   def initialize(attributes = {})
      super(attributes)      
      self.roles = [] if self.roles.nil?
      self.status = "active" if self.status.nil?
    end
end