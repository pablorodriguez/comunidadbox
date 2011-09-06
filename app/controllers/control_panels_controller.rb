class ControlPanelsController < ApplicationController
   layout "application", :except => [:find_models]
    
  def index   
    @company_services = current_user.company.service_type
    @not_in = (res = (@company_services.each {|x| x.id.to_i }).uniq).length == 0 ? '' : res
    @eventos_rojo = Event.count(:all,
                           :conditions => ["dueDate < ? and service_type_id IN (?) and status = ?", Time.now.months_since(1),@not_in,Status::ACTIVE],
                           :include => ['service_type'],
                           :group => ['service_type'])
    
    @eventos_amarillo = Event.count(:all,
                    :conditions => ["dueDate > ? AND dueDate < ? and service_type_id IN (?) and status = ?", Time.now.months_since(1),
                      Time.now.months_since(2),@not_in,Status::ACTIVE],
                    :include => ['service_type'],
                    :group => ['service_type'])
    
    @eventos_verde = Event.count(:all,
                     :conditions => ["dueDate > ? and service_type_id IN (?) and status = ? ", Time.now.months_since(2),@not_in,Status::ACTIVE],
                     :include => ['service_type'],
                     :group => ['service_type'])
     
    @eventos_total = Event.count(:all,
                            :conditions => ["service_type_id IN (?) and status = ?",  @not_in,Status::ACTIVE],
                            :include => ['service_type'],
                            :group => ['service_type'])
    
    
    @services_names= @company_services.inject(""){|result,service| result += "'#{service.name}',"}.chop
    
    g_data="name: '> 2 Meses',data:["
    y_data="name:'1 < Meses < 2',data:["
    r_data="name:'Meses < 1',data:["
    
    @no_data=false
    if (@eventos_verde.size == 0 && @eventos_amarillo.size == 0 && @eventos_rojo.size == 0)
      @no_data=true
    end
    
    @company_services.each do |service|
      g_data += "{y:#{@eventos_verde[service] ? @eventos_verde[service]: 0},st:#{service.id}},"
      y_data += "{y:#{@eventos_amarillo[service] ? @eventos_amarillo[service]: 0},st:#{service.id}},"
      r_data += "{y:#{@eventos_rojo[service] ? @eventos_rojo[service] : 0},st:#{service.id}},"
    end
    g_data.chop!  
    y_data.chop!
    r_data.chop!
    
    @series_data="[{#{g_data}]},{#{y_data}]},{#{r_data}]}]"
    
  end
  
  
  def company_services(company_id)
    CompanyService.find(:all,:conditions=>["company_id= ?",company_id],
      :joins=>:service_type,:order =>'service_types.name').collect{|p| p.service_type}        
  end
  
  def save_filter
    @service_filter = ServiceFilter.new(params[:service_filter])
    respond_to do |format|
      unless @service_filter.save
        flash[:notice] = 'El filtro no se pudo guardar'
      end
      redirect filter_alarms_control_panel
    end
  end
  
  def filter_alarms
    @filters = ServiceFilter.find(:all,:order => :name)
    @sf = params[:sf]
    unless @sf.blank?
      @sf=@sf.to_i
      @service_filter = ServiceFilter.find(@sf)
    else
      @sf=nil
      @service_filter = ServiceFilter.new(params[:service_filter])
    end
    
    @fuels = %w(Nafta Diesel Gas)
    @years = ((Time.now.year) -25)...((Time.now.year) +2)
    
    @states = State.all(:order=>:name)
    if params[:st]
      @service_filter.service_type_id = ServiceType.find(params[:st]).id
    end
    
    @company_services = current_user.current_company.service_type
    @brands = Brand.all(:order=>:name)    
    @models  = Array.new
    if @service_filter.brand_id
      @models = Model.find_all_by_brand_id(@service_filter.brand_id,:order=>:name)
    end
    
    events = Event.find_by_params @service_filter
    
    @red_cars = events.red
    @yellow_cars = events.yellow
    @green_cars = events.green
    
    @events = @red_cars + @yellow_cars + @green_cars
    current_page = params[:page] || 1
    per_page=10
    @page_events = @events.paginate(:page=>current_page,:per_page=>per_page)
    
  end
  
  def join_cars(rojos,amarillos,verdes)
    total = rojos.size
    
    if amarillos.size > total
      total = amarillos.size
    end
    
    if verdes.size > total
      total = verdes.size
    end
    events = Array.new
    for i in 0..total-1
      row = Array.new
      row[0]=rojos[i]
      row[1]=amarillos[i]
      row[2]=verdes[i]
      events << row
    end
    events
  end
  
  def new_offer
    @paramss = session[:filter_alarms]
  end
  
  def find_models
    @models = Model.find_all_by_brand_id(params[:brand_id],:order =>"name")
    @brand_id=params[:id]
    respond_to do |format|
      format.js
    end
  end
end
