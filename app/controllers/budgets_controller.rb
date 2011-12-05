class BudgetsController < ApplicationController
  # GET /budgets
  # GET /budgets.xml
  def index
    @budgets = Budget.all
    @service_type_ids =  params["service_type_ids"] || []
    @all_service_type = @service_type_ids.size > 0 ? true : false
    @company_services = current_user.company ? current_user.company.service_type : current_user.service_types
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @budgets }
    end
  end

  # GET /budgets/1
  # GET /budgets/1.xml
  def show
    @budget = Budget.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @budget }
    end
  end

  # GET /budgets/new
  # GET /budgets/new.xml
  def new
    @budget = Budget.new
    @service_types = current_user.service_types    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @budget }
    end
  end

  # GET /budgets/1/edit
  def edit
    @budget = Budget.find(params[:id])
    @service_types = current_user.service_types
    @company_services = current_user.company ? current_user.company.service_type : current_user.service_types
  end

  # POST /budgets
  # POST /budgets.xml
  def create
    @budget = Budget.new(params[:budget])
    @budget.creator = current_user
    respond_to do |format|
      if @budget.save
        format.html { redirect_to(budgets_path) }
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
    @service_types = current_user.service_types
    respond_to do |format|
      if @budget.update_attributes(params[:budget])
        format.html { redirect_to(@budget, :notice => 'Budget was successfully updated.') }
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
    @budget.destroy

    respond_to do |format|
      format.html { redirect_to(budgets_url) }
      format.xml  { head :ok }
    end
  end

  def print
    @budget = Budget.find params[:id]
    respond_to do |format|
      format.html
      format.pdf {
        prawnto :prawn => {
        :page_size => 'A4',
        :left_margin => 20,
        :right_margin => 20,
        :top_margin => 15,
        :bottom_margin => 15},
        :filename=>"presupuesto_#{@budget.id}.pdf"
        render :layout => false
        }
    end
  end

  def email
    budget = Budget.find params[:id]
    BudgetMailer.email(budget).deliver if budget
    redirect_to budget 
  end
end
