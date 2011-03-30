class EmployeesController < ApplicationController
  
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
    @user = User.find(params[:id])
   
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Empleado actualizado con exito.'
        format.html { redirect_to :action => "show" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
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
    @employees = current_user.current_company.employees
  end
  
  def edit
    @employee = User.find(params[:id])
  end
  
  def create
    @employee = User.new(params[:user])
    @employee.employer = current_user.company
    @employee.creator = current_user
    if @employee.save
      flash[:notice] = "Empleado creado exitosamente!"
      redirect_to employees_path
    else
      render :action => 'new'
    end
  end
    
end
