class ClientsController < ApplicationController
  layout "application", :except => [:search]
  
  def edit
    @user = User.find(params[:id])
    @models = Array.new
  end

  def update
    @client = User.find(params[:id])
    @models = Array.new
    if @client.update_attributes(params[:user])
      flash[:notice] = 'Cliente actualizado con exito.'
      redirect_to :root
    else
      flash[:notice]= 'Error al actualizar los datos'
      render :action => 'edit'
    end
  end
  
  def create
    @client = User.new(params[:user])
    
    if @client.save
        flash[:notice] = "Cliente creado exitosamente"
        redirect_to  new_workorder_path(:car_id =>@client.cars[0].id)
    else
      @client.cars.build unless @client.cars[0].domain
      @client.build_address unless @client.address
      render :action => 'new'
    end
  end
  
  def new
    @client = User.new
    @client.address = Address.new
    @client.cars.build
  end

  def index
    @clients = []
  end

  def search
    @condition = ''
    unless params[:first_name] == ''
      @condition += 'first_name=' + "'" + params[:first_name]+ "'"
    end
    unless params[:last_name] == ''
      unless @condition == ''
        @condition += ' AND '
      end
      @condition += 'last_name LIKE ' + "'%" +params[:last_name] + "%'"
    end
    unless params[:email] == ''
      unless @condition == ''
        @condition += ' AND '
      end
      @condition += 'email=' + "'" + params[:email] + "'"
    end
    @clients = User.find(:all, :conditions => @condition)

    respond_to do |format|
      format.js 
    end
  end
end

