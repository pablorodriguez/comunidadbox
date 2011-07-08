class CarsController < ApplicationController
  
  layout "application", :except => [:search,:update_km,:update_km_avg,:find_models] 
  skip_before_filter :authenticate_user!,:only => [:find_models]
 
  # GET /cars
  # GET /cars.xml
  def index
    page = params[:page] || 1
    domain = params[:domain] || "%"
    @user = current_user
    per_page = 15
    
    if current_user.company
      @company_cars = current_user.company.cars
    else
      @company_cars = current_user.cars
    end
    
    if  domain != "%"
      @company_cars = Car.where("domain like ?",domain)  
    end
    
    @company_id = params[:company_id]
    @company_cars = @company_cars.order("domain asc").paginate(:page =>page,:per_page =>per_page)
    
    respond_to do |format|
      format.html # index.html.erb
      format.js { render :layout => false}
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
    new_km = params[:update_value].to_i
    @car = Car.where("domain like ?",domain).first
    @car.update_km new_km
    @car.save
    @car.update_events
    respond_to do |format|
      format.js
    end
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
  
  def my
    page = params[:page] || 1
    if params[:id]
      @user = User.find params[:id]
    else
      @user = current_user
    end
    @cars = @user.cars.paginate(:per_page=>5,:page =>page)
  end
  
  # GET /cars/1
  # GET /cars/1.xml
  def show
    @car = Car.find(params[:id])
    page = params[:page] || 1
    data = params[:d] || "all"
    
    respond_to do |format|
      if data == "all"
        @work_orders = Workorder.where("car_id = ?",params[:id]).paginate(:all,:per_page=>5,:page =>page,:order =>"created_at desc")
        @events = @car.future_events.paginate(:per_page=>5,:page =>page)
        @wo_pages = {:d=>"wo"}
        @e_pages = {:d=>"e"}
        format.html # show.html.erb
        format.js { render "all",:layout => false} 
      end
      if data == "e"
        @events = @car.future_events.paginate(:per_page=>5,:page =>page)
        @e_pages = {:d =>"e"}
        format.js { render "events",:layout => false}        
      end
      
      if data =="wo"
        @work_orders = Workorder.where("car_id = ?",params[:id]).paginate(:all,:per_page=>5,:page =>page,:order =>"created_at desc")
        @wo_pages = {:d => "wo"}      
        format.js { render "work_orders",:layout => false}
      end


    end
  end

  # GET /cars/new
  # GET /cars/new.xml
  def new
    if params[:user_id]
      user = User.find params[:user_id]
    else
      user=current_user
    end
        
    @car = Car.new
    @car.user = user
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
    @car.company = current_user.company if current_user.company
    
    respond_to do |format|
      if @car.save
        flash[:notice] = t :car_created_exit
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
