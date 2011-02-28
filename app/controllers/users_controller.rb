class UsersController < ApplicationController
  layout "application", :except => [:find_models]

  skip_before_filter :authenticate_user!,:only => [:new,:create,:update,:login,:activate,:find_models, :change_pass]
  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless user_signed_in? || User.count > 0
  end
  
  def edit
    @user = current_user
    @user.address = Address.new if @user.address.nil?
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new_client
    @title = "Nuevo Cliente"
    @user = User.new
    @user.cars.build
    @user.build_address
    render :action=>'new'
  end

  def list_service_offer
    cars_ids = Array.new
    current_user.cars.each{|c| cars_ids << c.id}

    @car_service_offers = CarServiceOffer.all(:conditions=>["status in ('Enviado','Aceptado','Rechazado') and car_id in (?)",cars_ids])
  end

  def future_events    
    if current_user.company?
      @events = current_user.company.future_events
    else
      @events = current_user.future_events  
    end     
  end


  def create_client
    @user = User.new(params[:user])
    @user.creator = current_user if current_user
    
    if @user.save
        flash[:notice] = "Cliente creado exitosamente"
        redirect_to  new_workorder_path(:car_id =>@user.cars[0].id)
    else
      @user.cars.build unless @user.cars
      @user.build_address unless @user.address
      render :action => 'new'
    end
  end

end

