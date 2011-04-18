class Users::RegistrationsController < Devise::RegistrationsController
  
  def new
    @user = User.new
    @user.type ="fu"
    resource.address = Address.new if resource.address.nil?
    resource.cars.build if resource.cars.empty?
    @company = resource.companies.build
    @company.build_address if @company.address.nil?
  end
  
  def edit    
    resource.build_address if resource.address.nil?
    unless resource.company
      @company = resource.companies.build
      @company.active=1
      @company.build_address if @company.address.nil?
    end
    
  end
  
  def update
    @user = current_user
    no_company = @user.company == nil ? true:false
    
    @user.type = params[:user][:type]
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "Usuario actualizado exitosamente"
        if (@user.company && no_company)
          user_role = UserRole.new
          user_role.role = Role.find_by_name(Role::ADMINISTRATOR) 
          user_role.company = @user.company
          user_role.user = @user
          user_role.save
          PriceList.copy_default(@user.current_company.id)
        end
        format.html { redirect_to root_path }
        format.xml  { head :ok }
      else
        @user.build_address if @user.address.nil?
        logger.info "### #{resource.address}"
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
    
  end
  
  def create
    @user = User.new(params[:user])
    @user.type = params[:user][:type]
    
    @user.companies @user.type == "fs"
    
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
      @user.companies.build unless @user.companies
      
      if @user.companies.size == 0
        @company = @user.companies.build
        @company.build_address if @company.address.nil?
      end
      render :action => 'new'
    end
  end
  
end