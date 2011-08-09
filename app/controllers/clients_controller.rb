class ClientsController < ApplicationController
  layout "application", :except => [:search,:find_models]
  
  def edit
    @client = User.find(params[:id])
    @models = Array.new
  end

  def update
    @client = User.find(params[:id])
    @models = Array.new
    
    if @client.update_attributes(params[:user])
      flash[:notice] = 'Cliente actualizado con exito.'
      redirect_to clients_path
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
    @client.creator = current_user
    @client.password = @client.first_name + "test"
    @client.password_confirmation = @client.password
    
    User.transaction do
      if @client.save
          flash[:notice] = "Cliente creado exitosamente"
          @client.cars.each do |car|
            car.company = current_user.current_company
            car.save
          end
          redirect_to  new_workorder_path(:car_id =>@client.cars[0].id)
      else
        @client.cars.build if @client.cars.size == 0
        @client.build_address unless @client.address
        render :action => 'new'
      end
      
    end
  end
  
  def new
    @client = User.new
    @client.address = Address.new
    @client.cars.build
  end

  def index
    page = params[:page] || 1
    per_page = 15
    email = params[:email] || ""
    first_name = params[:first_name] || ""
    last_name = params[:last_name] || ""       
    @clients = User.where("cars.company_id = ?",current_user.company.id).includes(:cars)     
    @clients = @clients.where("first_name like ? and last_name like ? and email like ?","%#{first_name}%","%#{last_name}%","%#{email}%")
    @clients = @clients.order("first_name,last_name").paginate(:page =>page,:per_page =>per_page)
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

