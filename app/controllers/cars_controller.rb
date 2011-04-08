class CarsController < ApplicationController
  
  layout "application", :except => [:search,:update_km,:update_km_avg,:find_models] 
  skip_before_filter :authenticate_user!,:only => [:find_models]
 
  # GET /cars
  # GET /cars.xml
  def index
    if current_user.company
      @company_cars = Car.all(:conditions =>["company_id = ? or user_id = ?",current_user.company.id,current_user.id])
    elsif current_user.is_employee
      @company_cars = Car.all(:conditions =>["company_id = ? or user_id = ?",current_user.employer.id,current_user.id])
    else
      @company_cars = Car.find(:all,:conditions=>["user_id = ? ",current_user.id])
    end
    @company_id = params[:company_id]
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def find_models
    @models = Model.where("brand_id = ?",params[:brand_id]).order("name")
    respond_to do |format|
      format.js
    end
  end
  
  def update_km
    domain = params[:domain]
    new_value = params[:update_value]
    car = Car.find_by_domain domain
    car.km = new_value
    car.save
    car.update_events
    render :text => new_value
  end

  def update_km_avg
    domain = params[:domain]
    new_value = params[:update_value]
    car = Car.find_by_domain domain
    car.kmAverageMonthly = new_value
    car.save
    car.update_events
    render :text => new_value
  end
  
  def search
    domain = params[:car][:domain]
    @company_id = params[:company_id]
    @car_id = params[:car_id]
    unless domain == ''
      @cars = Car.all(:conditions =>["domain = ?",domain])
    else
      if current_user.company
        @cars = Car.all(:conditions =>["company_id = ? or user_id = ?",current_user.company.id,current_user.id])
      elsif current_user.is_employee
        @cars = Car.all(:conditions =>["company_id = ? or user_id = ?",current_user.employer.id,current_user.id])
      else
        @cars = Car.find(:all,:conditions=>["user_id = ? ",current_user.id])
      end
    end
    
    respond_to do |format|
      format.js
    end
    
  end
  
  # GET /cars/1
  # GET /cars/1.xml
  def show
    @car = Car.find(params[:id])
    page = params[:page] || 1
    @work_orders = Workorder.paginate(:all,:per_page=>13,:page =>page,:order =>"created_at desc",:conditions =>["car_id = ?",params[:id]])
    @events = @car.future_events.paginate(:per_page=>10,:page =>1)  
    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end

  # GET /cars/new
  # GET /cars/new.xml
  def new
    new_user=current_user
    unless params[:user_id].nil?
      new_user = User.find params[:user_id]
    end
    @car = Car.new
    @car.user = new_user
    @models = Array.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @car }
    end
  end

  # GET /cars/1/edit
  def edit
    @car = Car.find(params[:id])
    @models = Model.find_by_brand_id(@car.brand.id)
  end

  # POST /cars
  # POST /cars.xml
  def create
    @car = Car.new(params[:car])
    if @car.user.nil?
      @car.user = current_user
    end
    respond_to do |format|
      if @car.save
        flash[:notice] = t :car_crated_exit
        format.html { redirect_to(@car) }
        format.xml  { render :xml => @car, :status => :created, :location => @car }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @car.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cars/1
  # PUT /cars/1.xml
  def update
    @car = Car.find(params[:id])
    
    respond_to do |format|
      if @car.update_attributes(params[:car])
        @car.update_events
        flash[:notice] = t :car_updated_exit
        format.html { redirect_to(@car) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @car.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1
  # DELETE /cars/1.xml
  def destroy
    @car = Car.find(params[:id])
    @car.destroy

    respond_to do |format|
      format.html { redirect_to(cars_url) }
      format.xml  { head :ok }
    end
  end
  
end
