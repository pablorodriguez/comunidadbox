class EmployeesController < ApplicationController
  layout "application", :except => [:search]
  authorize_resource :class => false
  
  def new
    @employee = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def update
    @employee = User.find(params[:id])
   
    respond_to do |format|
      if @employee.update_attributes(params[:user])        
        format.html { redirect_to :action => "show" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @employee.errors, :status => :unprocessable_entity }
      end
    end
  end

  def activate
    @employee = User.find(params[:id])
    @employee.update_attribute(:disable,false)

    respond_to do |format|
      format.html { redirect_to(employees_url) }
      format.xml  { head :ok }
    end
  end
  
  def destroy
    @employee = User.find(params[:id])
    @employee.update_attribute(:disable,true)    

    respond_to do |format|
      format.html { redirect_to(employees_url) }
      format.xml  { head :ok }
    end
  end
  
  def index
    params[:employee_search].delete_if{|k,v| v.empty?} if params[:employee_search]
    @employee_search = EmployeeSearch.new(params[:employee_search])
    @employees = Company.employees(company_id,@employee_search)
    respond_to do |format|
      format.html
      format.js { render :layout => false}
    end
  end
  
  def edit
    @employee = User.find(params[:id])
  end
  
  def create
    @employee = User.new(params[:user])
    @employee.employer = current_user.company unless @employee.employer
    @employee.creator = current_user
    @employee.confirmed =1
    
    if @employee.save
      redirect_to employees_path
    else
      render :action => 'new'
    end
  end
    
   def search
    email = params[:email] || ""
    first_name = params[:first_name] || ""
    last_name = params[:last_name] || ""    
    @roles_ids = params[:roles_ids] ? params[:roles_ids].map{|v|v.to_i} : []    
    @active = true    
    @employees = Company.employees(company_id,@roles_ids,@active)    
    respond_to do |format|
      format.js { render :layout => false}
    end
   end
end
