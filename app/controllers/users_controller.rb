class UsersController < ApplicationController
  @@lock = Mutex.new
  layout "application", :except => [:find_models]

  skip_before_filter :authenticate_user!,:only => [:new,:create,:update,:login,:activate,:find_models, :change_pass]
  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless user_signed_in? || User.count > 0
  end
  
  def mail_confirmation
    @resource = current_user
    respond_to do |format|
      format.html { render :file=>"devise/mailer/confirmation_instructions",:layout => false }
    end
  end
  
  def reset_password
    @resource = current_user
    respond_to do |format|
      format.html { render :file=>"devise/mailer/reset_password_instructions",:layout => false }
    end
  end
  
  def unlock
    @resource = current_user
    #@resource.unlock_token="sdfsdfsadfds"
    respond_to do |format|
      format.html { render :file=>"devise/mailer/unlock_instructions",:layout => false }
    end
  end
  
  def show
    @user = User.find(params[:id])
  end

  def list_service_offer
    cars_ids = Array.new
    current_user.cars.each{|c| cars_ids << c.id}

    @car_service_offers = CarServiceOffer.all(:conditions=>["status in ('Enviado','Aceptado','Rechazado') and car_id in (?)",cars_ids])
  end

  def future_events    
    if company_id
      @events = get_company.future_events
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

  def generate_email
    @email_generated =  User.generate_email
    respond_to do |format|
      format.js { render :layout => false}
    end
  end

  def validate_email
    @user =  User.find_by_email(params[:email])
    respond_to do |format|
      if @user
        format.js { render :file => "users/invalid_email", :layout => false}
      else
        format.js { render :file => "users/valid_email",:layout => false}
      end
    end
  end

  def validate_domain
    @car =  Car.find_by_domain(params[:domain])    
    respond_to do |format|
      if @car
        @user = @car.user
        format.js { render :file => "users/invalid_domain", :layout => false}
      else
        format.js { render :file => "users/valid_domain",:layout => false}
      end
    end
  end
end

