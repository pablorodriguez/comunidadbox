class Users::RegistrationsController < Devise::RegistrationsController
  layout 'application'
  def new
    build_resource({})
    resource.type ="fu"
    set_default_data resource
    respond_to do |format|
      format.js { render :layout => false}
      format.html # new.html.erb
    end
  end
  
  def edit
    resource.build_address unless resource.address
    unless resource.company
      company = resource.companies.build
      company.active=1
      company.build_address unless company.address
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
          PriceList.copy_default(@user.company.id)
        end
        format.html { redirect_to root_path }
        format.xml  { head :ok }
      else
        @user.build_address if @user.address.nil?        
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
    
  end
  
  def create
    build_resource
    resource.type = params[:user][:type]
    resource.confirmed = true
    if resource.companies.size > 0
       resource.companies.first.active = true
       resource.confirmed=false
       resource.roles << Role.find_by_name(Role::ADMINISTRATOR) 
    end
    if verify_recaptcha  
      if resource.save
          flash[:notice] = "Cliente creado exitosamente"
          if (resource.company &&  (!resource.is_employee?))
            PriceList.copy_default(resource.company.id)
          end
          redirect_to new_user_session_path
      else
        set_default_data resource
        render :action => 'new'
      end
    else 
      set_default_data resource     
      flash.delete(:recaptcha_error)
      resource.errors.add "Validacion", "Hubo un error en la validacion del codigo de reCaptcha. Por favor ingreselo nuevamente."
      render :new
    end
   
  end

  private

  #Set User entity with default data
  def set_default_data user
    user.cars.build if user.cars.empty?
    user.build_address unless user.address
    user.companies.build unless user.companies
    
    if user.companies.empty?
      company = user.companies.build
      company.build_address if company.address.nil?
    end
  end
end