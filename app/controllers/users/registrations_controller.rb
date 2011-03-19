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
  
  def create
    puts "#########################################"
    @user = User.new(params[:user])
    
    if @user.save
        flash[:notice] = "Cliente creado exitosamente"
        redirect_to  new_workorder_path(:car_id =>@user.cars[0].id)
    else
      @user.cars.build unless @user.cars[0].domain
      @user.build_address unless @user.address
      render :action => 'new'
    end
  end
  
end