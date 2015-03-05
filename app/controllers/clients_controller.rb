# encoding: utf-8
class ClientsController < ApplicationController
  layout "application", :except => [:search,:find_models]
  authorize_resource :class => false

  def edit
    @client = User.find(params[:id])

    @client.build_address unless @client.address
    @models = Array.new

    unless current_user.is_client?(@client)
      flash[:notice] = "No puede modificar un cliente que no es suyo"
      return redirect_to clients_path
    end

    respond_to do |format|
      format.html
    end
  end

  def show
    @client = User.find(params[:id])
    @is_client = current_user.is_client?(@client)

    respond_to do |format|
      format.html
    end
  end


  # DELETE /cars/1
  # DELETE /cars/1.xml
  def destroy
    @client = User.find(params[:id])
    authorize! :destroy, @client
    @client.destroy

    respond_to do |format|
      format.js { render :layout => false}
    end
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
        # @client.companies_users.build(user_id: @client, company_id: company_id)
      end
    end

    @client.vehicles.first.company = get_company if @client.vehicles.first

    @budget = Budget.find(params[:budget_id]) if params[:budget_id]

    if @client.save
        if params[:budget_id]
          @budget.user = @client
          @budget.vehicle = @client.vehicles.last
          @budget.save
          logger.debug "#### Budget ID #{params[:budget_id]} user id #{@client.id} #{@budget.user.id}"
        end


        #Si no hay auto, muestro error y voy al new
        if @client.vehicles.empty?
          if @budget
            logger.debug "### debe ingresar un auto"
            @client.errors.add "Automovil", "Debe ingresar informacion del automovil"
            @client.vehicles.build if @client.vehicles.empty?
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
            logger.debug "### va a nueva orden de trabajo con #{@client.vehicles.first.id}"
            redirect_to new_workorder_path(:vehicle_id =>@client.vehicles.first.id)
          end

          if @budget
            logger.debug "### va a nueva orden de trabajo con budget #{@budget.id}"
            #si hay auto y hay budget voy a crear orden de trabajo para el auto y el budget
            redirect_to new_workorder_path(:b => @budget.id)
          end
        end

    else
      @client.vehicles.build if @client.vehicles.empty?
      @client.build_address unless @client.address
      logger.debug "### voy a new action error"
      # si hay error voy al view
      render :action => 'new'
    end

  end

  def new
    @client = User.new
    @client.build_address
    @client.vehicles.build(type: 'Car')
    @client.vehicles.build(type: 'Motorcycle')
    # @client.cars.build
    # @client.motorcycles.build
    if params[:b]
      @budget = Budget.find params[:b]
      @client.first_name = @budget.first_name
      @client.last_name =  @budget.last_name
      @client.email = @budget.email
      @client.phone = @budget.phone

      # car
      @client.vehicles.detect { |v| v["type"] == 'Car' }.domain = @budget.domain
      @client.vehicles.detect { |v| v["type"] == 'Car' }.brand = @budget.brand
      @client.vehicles.detect { |v| v["type"] == 'Car' }.model =@budget.model
      # @client.vehicles.first.domain = @budget.domain
      # @client.vehicles.first.brand = @budget.brand
      # @client.vehicles.first.model =@budget.model
      # motorcycle
      @client.vehicles.detect { |v| v["type"] == 'Motorcycle' }.domain = @budget.domain
      @client.vehicles.detect { |v| v["type"] == 'Motorcycle' }.brand = @budget.brand
      @client.vehicles.detect { |v| v["type"] == 'Motorcycle' }.model =@budget.model
      # @client.vehicles.last.domain = @budget.domain
      # @client.vehicles.last.brand = @budget.brand
      # @client.vehicles.last.model =@budget.model

      # @client.cars.first.domain = @budget.domain
      # @client.cars.first.brand = @budget.brand
      # @client.cars.first.model =@budget.model
      # @client.motorcycles.first.domain = @budget.domain
      # @client.motorcycles.first.brand = @budget.brand
      # @client.motorcycles.first.model =@budget.model
      flash.now.notice ="Antes de registrar un servicio por favor cree el cliente"
    end
    respond_to do |format|
      format.html
    end
  end

  def index
    page = params[:page] || 1
    @clients = Company.clients(current_user.get_companies_ids,params).paginate(:page =>page,:per_page =>15)

    @filters_params_exp = params

    respond_to do |format|
      format.html
      format.js { render :layout => false}
    end
  end


  def index_all
    @clients = Company.clients current_user.get_companies_ids,params

    respond_to do |format|
      format.js { render :action => "index", :layout => false}
    end
  end

  def search2
    page = params[:page] || 1
    per_page = 15
    email = params[:email] || ""
    first_name = params[:first_name] || ""
    last_name = params[:last_name] || ""
    @vehicles = Vehicle.where("users.creator_id = ? and confirmed_at is null",current_user.id).includes(:user)
    @vehicles = @vehicles.where("users.first_name like ? and users.last_name like ? and users.email like ?","%#{first_name}%","%#{last_name}%","%#{email}%")
    @vehicles = @vehicles.paginate(:page =>page,:per_page =>per_page)

    respond_to do |format|
      format.js
    end
  end

  def export

    csv = Company.clients_report_to_csv current_user.get_companies_ids, params

    unless csv.empty?

      respond_to do |format|
        format.csv {
          send_data csv.encode("utf-16", {:invalid => :replace, :undef => :replace, :replace => '?'}), :filename => "clientsReport.csv", :type => 'text/csv; charset=iso-8859-1; header=present'
        }
      end

    else
      flash[:alert] = t("Error")
      redirect_to clients_path
    end
  end

  def import
    respond_to do |format|
      format.html
    end
  end

  def upload
    file = params[:file]

    #validar que exista un file.. sino mostrar algun mensaje de error

    @import_result = User.import_clients file, current_user, get_company

    render :action => 'import'
  end

end

