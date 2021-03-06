# encoding: utf-8
class ClientsController < ApplicationController
  layout "application", :except => [:search,:find_models]
  authorize_resource :class => false

  def edit
    @client = User.find(params[:id])
    authorize! :update, @client
    @company = get_company
    @client.build_address unless @client.address
    
    respond_to do |format|
      format.html
    end
  end

  def show
    @client = User.find(params[:id])
    authorize! :read, @client
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
      format.html {redirect_to clients_path}
      format.js { render :layout => false}

    end
  end

  def update
    @client = User.find(params[:id])
    
    if @client.update_attributes(params[:user])
      redirect_to client_path @client
    else
      @company = get_company
      @brands = @company.get_brands.order(:name)
      @models = @client.vehicles.first.brand_id ? @client.vehicles.first.brand.models : []

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
    @client.creator = current_user
    @client.vehicles.first.company = get_company if @client.vehicles.first
    @company = get_company

    # pro que esto ? si el cliente no tiene address le copiamos la dle empleado que lo registro ? REVISAR
    unless @client.address
      @client.address = current_user.address if current_user.address
    end

    @budget = Budget.find(params[:budget_id]) if params[:budget_id]
    @client.companies_users.build({:company_id => @company.id})
    @brands = @company.get_brands.order(:name)
    @models = (@client.vehicles.first && @client.vehicles.first.brand_id) ? @client.vehicles.first.brand.models : []

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
      @client.build_address unless @client.address.present?
      render :action => 'new'
    end

  end

  def new
    @client = User.new
    @client.build_address
    @client.vehicles.build
    @client.email = ""
    @company = get_company
    @brands = @company.get_brands.order(:name)
    @models = []
    if params[:b]
      @budget = Budget.find params[:b]
      @client.first_name = @budget.first_name
      @client.last_name =  @budget.last_name
      @client.email = @budget.email
      @client.phone = @budget.phone
      @client.vehicles.first.domain = @budget.domain
      @client.vehicles.first.brand = @budget.brand
      @client.vehicles.first.model =@budget.model
      @models = @budget.brand.models if @budget.brand
      flash.now.notice ="Antes de registrar un servicio por favor cree el cliente"
    end
    
    respond_to do |format|
      format.html
    end
  end

  def index
    page = params[:page] || 1
    params.delete_if{|k,v| v.empty?}
    if search_multiple_company(params)
      params[:companies_ids] = current_user.get_companies_ids
    else
      params[:companies_ids] = get_company
    end

    @clients = Company.clients(params).paginate(:page =>page,:per_page =>15)
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
          send_data csv.encode("iso-8859-1"), :filename => "clientsReport.csv", :type => 'text/csv; charset=iso-8859-1; header=present'
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
    @import_result = User.import_clients file, current_user, get_company,get_user_agent_encode
    flash[:alert] = @import_result[:fatal] if @import_result[:fatal]
    render :action => 'import'
  end

  def search_multiple_company params
    fields = %W{date_from date_to first_name last_name company_name material number chassis domain wo_status_id}
    value = false
    fields.each do |field|
      return field if (params[field] != nil)
    end
    value
  end

end

