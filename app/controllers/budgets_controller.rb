# encoding: utf-8
class BudgetsController < ApplicationController

  # GET /budgets
  # GET /budgets.xml
  def index
    page = params[:page] || 1
    per_page = 10

    @company_services = get_service_types
    @service_type_ids =  params[:service_type_ids] || []
    @all_service_type = @service_type_ids.size > 0 ? true : false

    filters_params ={}
    @date_f = params[:date_from]
    @date_t = params[:date_to]
    @domain = params[:domain]
    @budget_id = params[:number]

    filters_params[:first_name] = params[:first_name] if (params[:first_name] && !(params[:first_name].empty?))
    filters_params[:last_name] = params[:last_name] if (params[:last_name] && !(params[:last_name].empty?))
    filters_params[:date_from] = @date_f if (@date_f && (!@date_f.empty?))
    filters_params[:date_to] =  @date_t if (@date_t && (!@date_t.empty?))
    filters_params[:domain] = @domain if(params[:domain] && !(params[:domain].empty?))
    filters_params[:service_type_ids] = @service_type_ids  unless (@service_type_ids.empty?)
    filters_params[:company_id] = company_id
    filters_params[:user] = current_user
    filters_params[:budget_id] = @budget_id if (@budget_id && (!@budget_id.empty?))
    filters_params[:brand_id] = params[:brand_id] if params[:brand_id] && !(params[:brand_id].empty?)
    filters_params[:model_id] = params[:service_filter][:model_id] if params[:service_filter] && !(params[:service_filter][:model_id].empty?)
    filters_params[:year] = params[:year] if(params[:year] && !(params[:year].empty?))

    @filters_params_exp = filters_params
    @filters_params_exp[:user] = nil

    @budgets = Budget.find_by_params(filters_params).paginate(:page =>page,:per_page =>per_page)

    @fuels = Vehicle.fuels
    @years = ((Time.zone.now.year) -25)...((Time.zone.now.year) +2)
    @states = State.order(:name)
    @company_services = get_service_types
    @brands = Brand.order(:name)

    @models = Array.new
    @models = Model.find_all_by_brand_id(filters_params[:brand_id],:order=>:name) if filters_params[:brand_id]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @budgets }
      format.js { render :layout => false}
    end
  end

  def export
    params[:user] = current_user

    csv = Budget.budget_report_to_csv params

    unless csv.empty?

      respond_to do |format|
        format.csv { send_data csv.encode("utf-16", {:invalid => :replace, :undef => :replace, :replace => '?'}), :filename => "budgetsReport.csv", :type => 'text/csv; charset=iso-8859-1; header=present'}
      end

    else
      flash[:alert] = t("Error")
      redirect_to badgets_path
    end
  end

  # GET /budgets/1
  # GET /budgets/1.xml
  def show
    @budget = Budget.find(params[:id])
    authorize! :read, @budget

    @client = @budget
    @client = @budget.user if @budget.user
    @client = @budget.vehicle.user if @budget.vehicle

    @vehicle = @budget
    @vehicle = @budget.vehicle if @budget.vehicle

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @budget }
    end
  end

  # GET /budgets/new
  # GET /budgets/new.xml
  def new
    @budget = Budget.new
    authorize! :create, @budget

    @service_types = get_service_types
    if params[:c]
      c = User.find(params[:c])
      @budget.user = c if c
      #@budget.vehicle = c.vehicles.first if c.vehicles.size == 1
    end
    if params[:ca]
      ca = Vehicle.find(params[:ca])
      @budget.vehicle = ca if ca
      @budget.user = ca.user
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @budget }
    end
  end

  # GET /budgets/1/edit
  def edit
    @budget = Budget.find(params[:id])
    authorize! :update, @budget

    @service_types = get_service_types
  end

  # POST /budgets
  # POST /budgets.xml
  def create
    @budget = Budget.new(params[:budget])

    authorize! :create, @budget

    @budget.creator = current_user
    @budget.company = get_company

    respond_to do |format|
      if @budget.save
        format.html { redirect_to(@budget) }
        format.xml  { render :xml => @budget, :status => :created, :location => @budget }
      else
        @service_types = current_user.service_types
        format.html { render :action => "new" }
        format.xml  { render :xml => @budget.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /budgets/1
  # PUT /budgets/1.xml
  def update
    @budget = Budget.find(params[:id])
    authorize! :update, @budget

    @service_types = get_service_types
    respond_to do |format|
      if @budget.update_attributes(params[:budget])
        format.html { redirect_to(@budget) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @budget.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /budgets/1
  # DELETE /budgets/1.xml
  def destroy
    @budget = Budget.find(params[:id])
    authorize! :destroy, @budget

    @budget.destroy

    respond_to do |format|
      format.html { redirect_to(budgets_url) }
      format.js { render :layout => false}
    end
  end

  def print
    @budget = Budget.find params[:id]
    authorize! :read, @budget

    @client = @budget
    @client = @budget.user if @budget.user
    @client = @budget.vehicle.user if @budget.vehicle

    @vehicle = @budget
    @vehicle = @budget.vehicle if @budget.vehicle

    respond_to do |format|
      format.html
      format.pdf {
        prawnto :prawn => {
        :page_size => 'A4',
        :left_margin => 20,
        :right_margin => 20,
        :top_margin => 15,
        :bottom_margin => 15,
        :page_layout => :portrait},
        :filename=>"presupuesto_#{@budget.id}.pdf"
        render :layout => false
        }
    end
  end

  def email
    budget_id = params[:id]
    logger.info "### envio de email del budget #{budget_id}"
    Resque.enqueue(BudgetJob,budget_id)

    respond_to do |format|
      format.html {redirect_to budget }
      format.js { render :layout => false}
    end

  end

  def email_s
    @budget = Budget.find params[:id]

    @client = @budget
    @client = @budget.user if @budget.user
    @client = @budget.vehicle.user if @budget.vehicle

    @vehicle = @budget
    @vehicle = @budget.vehicle if @budget.vehicle

    respond_to do |format|
      format.html { render :file=>"budget_mailer/email",:layout => "emails" }
    end
  end
end
