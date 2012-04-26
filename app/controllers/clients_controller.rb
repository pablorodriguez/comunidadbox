class ClientsController < ApplicationController
  layout "application", :except => [:search,:find_models]

  def edit
    @client = User.find(params[:id])

    @client.address = Address.new unless @client.address
    @models = Array.new

    unless current_user.is_client?(@client)
      flash[:notice] = "No puede modificar un cliente que no es suyo"
      redirect_to clients_path
    end

  end

  def show
    @client = User.find(params[:id])
    @is_client = current_user.is_client @client
  end

  def update
    @client = User.find(params[:id])    
    @models = Array.new

    if @client.update_attributes(params[:user])
      render :action =>"show"
    else
      flash[:notice]= 'Error al actualizar los datos'
      render :action => 'edit'
    end
  end

  def find_models
    @models = Model.where("brand_id = ?",params[:brand_id]).order("name")
    @brand_id=params[:id]
    respond_to do |format|
      format.js
    end
  end

  def create
    @client = User.new(params[:user])
    @client.confirmed = true

    @client.creator = current_user
    @client.password = @client.first_name + "test"
    @client.password_confirmation = @client.password

    unless @client.address
      @client.address = current_user.address if current_user.address
    end

    if @client && company_id
      unless @client.service_centers.include?(get_company)
        @client.service_centers << get_company
      end
    end

    @client.cars.first.company = get_company if @client.cars.first

    @budget = Budget.find(params[:budget_id]) if params[:budget_id]
    
    if @client.save
        if params[:budget_id]    
          @budget.user = @client
          @budget.car = @client.cars.last
          @budget.save            
          logger.debug "#### Budget ID #{params[:budget_id]} user id #{@client.id} #{@budget.user.id}"  
      end
        
        
        #Si no hay auto, muestro error y voy al new 
        if @client.cars.empty?
          if @budget
            logger.debug "### debe ingresar un auto"
            @client.errors.add "", "Debe ingresar informacion del automovil"
            @client.cars.build if @client.cars.empty?
            @client.build_address unless @client.address
            render :action => 'new'
          else
            logger.debug "### va a listado de clientes"
            #si no hay auto y no hay budget id voy a lista de clientes          
            redirect_to clients_path 
          end
        else
          #si hay auto y no hay auto voy a crear orden de trabajo para el auto
          unless @budget
            logger.debug "### va a nueva orden de trabajo con #{@client.cars.first.id}"
            redirect_to new_workorder_path(:car_id =>@client.cars.first.id)
          end
          
          if @budget
            logger.debug "### va a nueva orden de trabajo con budget #{@budget.id}"
            #si hay auto y hay budget voy a crear orden de trabajo para el auto y el budget
            redirect_to new_workorder_path(:b => @budget.id) 
          end
        end
        
    else
      @client.cars.build if @client.cars.empty?
      @client.build_address unless @client.address
      logger.debug "### voy a new action error"
      # si hay error voy al view        
      render :action => 'new'
    end
  
  end

  def new
    @client = User.new
    @client.address = Address.new
    @client.cars.build
    if params[:b]
      @budget = Budget.find params[:b]
      @client.first_name = @budget.first_name
      @client.last_name =  @budget.last_name
      @client.email = @budget.email
      @client.phone = @budget.phone

      @client.cars.first.domain = @budget.domain
      @client.cars.first.brand = @budget.brand
      @client.cars.first.model =@budget.model
      flash.now.notice ="Antes de registrar un servicio por favor cree el cliente"
    end
  end

  def index
    per_page = 15
    page = params[:page] || 1    
    email = params[:email] || ""
    first_name = params[:first_name] || ""
    last_name = params[:last_name] || ""
    company_name = params[:company_name] || ""


    @clients = User.company_clients(current_user.companies.map(&:id))
    @clients = @clients.where("first_name like ?","%#{first_name}%") unless first_name.empty?
    @clients = @clients.where("last_name like ?","%#{last_name}%") unless last_name.empty?
    @clients = @clients.where("email like ?","%#{email}%") unless email.empty?
    @clients = @clients.where("company_name like ?","%#{company_name}%") unless company_name.empty?
    @clients = @clients.order("last_name,first_name").paginate(:page =>page,:per_page =>per_page)

    respond_to do |format|
      format.html
      format.js { render :layout => false}
    end
  end

  def search2
    page = params[:page] || 1
    per_page = 15
    email = params[:email] || ""
    first_name = params[:first_name] || ""
    last_name = params[:last_name] || ""
    @cars = Car.where("users.creator_id = ? and confirmed_at is null",current_user.id).includes(:user)
    @cars = @cars.where("users.first_name like ? and users.last_name like ? and users.email like ?","%#{first_name}%","%#{last_name}%","%#{email}%")
    @cars = @cars.paginate(:page =>page,:per_page =>per_page)

    respond_to do |format|
      format.js
    end
  end
end

