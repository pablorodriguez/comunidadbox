class CarsController < ApplicationController
  
  layout "application", :except => [:search,:update_km,:update_km_avg,:find_models] 
  skip_before_filter :authenticate_user!,:only => [:find_models,:update_km,:update_km_avg]
 
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
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def find_models
    @models = Model.find_all_by_brand_id(params[:brand_id],:order =>"name")
    @brand_id=params[:id]
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
    render :text => new_value
  end

  def update_km_avg
    domain = params[:domain]
    new_value = params[:update_value]
    car = Car.find_by_domain domain
    car.kmAverageMonthly = new_value
    car.save
    render :text => new_value
  end
  
  def search
    domain = params[:car][:domain]
    @cars = Car.all(:conditions =>["domain = ?",domain])
    respond_to do |format|
      format.js
    end
    
  end
  
  # GET /cars/1
  # GET /cars/1.xml
  def show
    @car = Car.find(params[:id])
    page = params[:page] || 1
    @work_orders = Workorder.paginate(:all,:per_page=>13,:page =>page,:conditions =>["car_id = ?",params[:id]])  
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @car }
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
    @models = find_model(@car.brand.id)
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
        flash[:notice] = 'Car was successfully created.'
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
        flash[:notice] = 'Car was successfully updated.'
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
