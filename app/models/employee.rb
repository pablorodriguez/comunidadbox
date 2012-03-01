class Employee < ActiveRecord::Base
  #set_table_name("users")
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable,:rememberable, :trackable, :validatable  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
  belongs_to :company
  
end
