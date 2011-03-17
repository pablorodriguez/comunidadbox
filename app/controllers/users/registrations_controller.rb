class Users::RegistrationsController < Devise::RegistrationsController
  
  def new
    @user = User.new
    resource.address = Address.new if resource.address.nil?
    resource.cars.build if resource.cars.empty?
  end
  
  def edit    
    resource.address = Address.new if resource.address.nil?
    resource.cars.build if resource.cars.empty?
  end
  
end