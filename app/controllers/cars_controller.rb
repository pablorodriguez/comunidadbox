class CarsController < ApplicationController
  
  layout "application", :except => [:search,:update_km,:update_km_avg,:find_models] 
  skip_before_filter :authenticate_user!,:only => [:find_models]
 
  # GET /cars
  # GET /cars.xml
  def index
    if current_user.company
      @company_cars = current_user.company.cars
    elsif current_user.is_employee
      @company_cars = current_user.employer.cars
    else
      @company_cars = current_user.cars
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
    @cars = current_user.cars
    logger.info "### car size #{@cars.size}"
  end
  
  def search
    domain = params[:car][:domain]
    if (domain.nil? || domain.empty?)
      domain = "%"
    end
    
    if current_user.company
      unless domain == "%"
        @cars = Car.where("domain like ?",domain)
      else
        @cars = current_user.company.cars
      end
    else
      @cars = current_user.cars.where("domain like ?",domain)
    end
    
    @company_id = params[:company_id]
    @car_id = params[:car_id]
    
    respond_to do |format|
      format.js
    end
    
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
