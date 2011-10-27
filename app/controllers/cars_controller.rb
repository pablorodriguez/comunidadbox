class CarsController < ApplicationController

  add_breadcrumb "Buscar", :all_companies_path
  add_breadcrumb "Autos", :cars_path  
  
  layout "application", :except => [:search,:update_km,:update_km_avg,:find_models,:search_companies] 
  skip_before_filter :authenticate_user!,:only => [:find_models]
 
  # GET /cars
  # GET /cars.xml
  def index
    page = params[:page] || 1
    domain = (params[:domain].strip if params[:domain]) || "%"
    domain = "%" if domain.empty?
     
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

  def service_done
  end
  
  def find_models
    @models = Model.where("brand_id = ?",params[:brand_id]).order("name")
    respond_to do |format|
      format.js
    end
  end
  
  def update_km
    domain = params[:domain]
    new_value = params[:update_value].to_i    
    car = Car.find_by_domain domain
    car.km = new_value
    car.save
    car.update_events
    render :text => new_value
  end

  def update_km_avg
    domain = params[:domain]
    new_value = params[:update_value].to_i
    car = Car.find_by_domain domain
    car.kmAverageMonthly = new_value
    car.save
    car.update_events
    render :text => new_value
  end
  
  def my
    page = params[:page] || 1
    @companies = Company.best current_user.state
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
    @car_id = params[:id]
    @usr = @car.user.id
    page = params[:page] || 1
    data = params[:d] || "all"
    filters ={}

    add_breadcrumb "Servicios", workorders_path
    add_breadcrumb "Panel de Control", control_panels_path if current_user.company

    respond_to do |format|

      if data == "all"
        @work_orders = Workorder.includes(:payment_method,:ranks,:company).where("car_id = ?",@car_id).order("performed desc")
          .paginate(:per_page=>5,:page =>page)
        filters[:domain] = @car.domain
        filters[:user] = current_user
        #filters[:company_id] = current_user.company.id if current_user.company
        @price_data = Workorder.build_graph_data(Workorder.group_by_service_type(filters))
        @companies = Company.best current_user.state 
        @notes = Note.where("user_id = ?",@car.user.id).order("created_at desc")
        
        @events = @car.future_events.paginate(:per_page=>10,:page =>page)
        @wo_pages = {:d=>"wo"}
        @e_pages = {:d=>"e"}
        logger.debug  "### Events #{@events.size} #{@price_data} "
        format.html # show.html.erb
        format.js { render "all",:layout => false} 
      end
      if data == "e"
        @events = @car.future_events.paginate(:per_page=>10,:page =>page)
        @e_pages = {:d =>"e"}
        format.js { render "events",:layout => false}        
      end
      
      if data =="wo"
        @work_orders = Workorder.where("car_id = ?",@car_id).paginate(:per_page=>5,:page =>page,:order =>"performed desc")
        @wo_pages = {:d => "wo"}      
        format.js { render "work_orders",:layout => false}
      end


    end
  end
  def search_companies   
    @companies = Company.search params
    @car_id = params[:car_id]
    respond_to do |format|
      format.js
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
