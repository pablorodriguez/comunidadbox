class Users::RegistrationsController < Devise::RegistrationsController
  
  def new
    @user = User.new
    resource.address = Address.new if resource.address.nil?
    resource.cars.build if resource.cars.empty?
    @company = resource.companies.build
    @company.build_address if @company.address.nil?
  end
  
  def edit    
    resource.build_address if resource.address.nil?
    resource.cars.build if resource.cars.empty?
    unless resource.company
      @company = resource.companies.build
      @company.build_address if @company.address.nil?
    end
    
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.companies.size > 0
       @user.companies[0].active=1
       @user.roles << Role.find_by_name(Role::ADMINISTRATOR) 
    end
    
    if @user.save
        flash[:notice] = "Cliente creado exitosamente"
        if (@user.current_company &&  (!@user.is_employee))
          PriceList.copy_default(@user.current_company.id)
        end
        redirect_to new_user_session_path
    else
      @user.cars.build if @user.cars.size == 0
      @user.build_address unless @user.address
      @company = @user.companies.build if @user.companies.size == 0
      @company.build_address if @company.address.nil?
      render :action => 'new'
    end
  end
  
end