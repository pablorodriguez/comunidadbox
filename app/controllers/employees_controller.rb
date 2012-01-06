class EmployeesController < ApplicationController
  layout "application", :except => [:search]
  
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
        flash[:notice] = 'Empleado actualizado con exito.'
        format.html { redirect_to :action => "show" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @employee.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @employee = User.find(params[:id])
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to(employees_url) }
      format.xml  { head :ok }
    end
  end
  
  def index
    @employees = get_company.employees
  end
  
  def edit
    @employee = User.find(params[:id])
  end
  
  def create
    @employee = User.new(params[:user])
    @employee.employer = get_company
    @employee.creator = current_user
    @employee.confirmed = true
    
    if @employee.save
      flash[:notice] = "Empleado creado exitosamente!"
      redirect_to employees_path
    else
      render :action => 'new'
    end
  end
    
   def search
    email = params[:email] || ""
    first_name = params[:first_name] || ""
    last_name = params[:last_name] || ""
    @employees = User.where("employer_id like ? and first_name like ? and last_name like ? and email like ?",
      company_id,"%#{first_name}%","%#{last_name}%","%#{email}%")
   
    respond_to do |format|
      format.js 
    end
   end
end
