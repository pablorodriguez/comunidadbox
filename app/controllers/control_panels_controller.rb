class ControlPanelsController < ApplicationController
   layout "application", :except => [:find_models]
    
  def index   
    @company_services = company_services(current_user.company.id)
    @not_in = (res = (@company_services.each {|x| x.id.to_i }).uniq).length == 0 ? '' : res
    @eventos_rojo = Event.count(:all,
                           :conditions => ["dueDate < ? and service_type_id IN (?)", Time.now.months_since(1),@not_in],
                           :include => ['service_type'],
                           :group => ['service_type'])
    
    @eventos_amarillo = Event.count(:all,
                    :conditions => ["dueDate > ? AND dueDate < ? and service_type_id IN (?)", Time.now.months_since(1), Time.now.months_since(2),@not_in],
                    :include => ['service_type'],
                    :group => ['service_type'])
    
    @eventos_verde = Event.count(:all,
                     :conditions => ["dueDate > ? and service_type_id IN (?) ", Time.now.months_since(2),@not_in],
                     :include => ['service_type'],
                     :group => ['service_type'])
     
    @eventos_total = Event.count(:all,
                            :conditions => ["service_type_id IN (?)",  @not_in],
                            :include => ['service_type'],
                            :group => ['service_type'])
    
    @url_map = map_url_str @company_services,@eventos_rojo,@eventos_amarillo,@eventos_verde
    
    @services_names= @service_data.inject(""){|result,service| result += "'#{service.name}',"}.chop
    
    g_data="name: '> 2 Meses',data:["
    y_data="name:'1 < Meses < 2',data:["
    r_data="name:'Meses < 1',data:["
    
    @service_data.each do |service|
      g_data += "#{@eventos_verde[service] ? @eventos_verde[service]: 0},"
      y_data += "#{@eventos_amarillo[service] ? @eventos_amarillo[service]: 0},"
      r_data += "#{@eventos_rojo[service] ? @eventos_rojo[service] : 0},"
    end
    g_data.chop!  
    y_data.chop!
    r_data.chop!
    
    @series_data="[{#{g_data}]},{#{y_data}]},{#{r_data}]}]"
    
    if @url_map
      @url_map_json = @url_map + "&chof=json"    
    end        
     
  end
  
 
  
  def map_url_str(services,e_r,e_a,e_v)
    rdata="t:"
    adata=""
    vdata=""
    labels = Array.new
    @service_data = Array.new
    services.each do |service|
      unless (e_r[service].nil? && e_a[service].nil? && e_v[service].nil?)
        rdata += "#{n(e_r[service])}," 
        adata += "#{n(e_a[service])}," 
        vdata += "#{n(e_v[service])}," 
        labels << service.name 
        @service_data << service
      end
    end
    url ="http://chart.apis.google.com/chart"
    if rdata != "t:"
        @rdata = rdata.chomp!(",") + "|" + adata.chomp!(",") + "|" + vdata.chomp!(",")
        labels_str = labels.reverse!.join("|")
        @rdata.chomp!(",")
        chm="N,FF0000,-1,,12|N,000000,0,,12,,c|N,000000,1,,12,,c|N,000000,2,,12,,c"
        chco="FF9999,FFFFA0,A0FFA0" 
        chbh="50,5,15"
        chs="chs=500x" + ((65 * labels.size)+2).to_s
        chxl="0:|" + labels_str
        chxr="1,0,10"
        chdl="< 1 Mes|1 < Mes < 2|> 2 Meses"
        chxs="0,FF0000,18"
        link = "#{url}?#{chs}&chd=#{@rdata}&chbh=#{chbh}&cht=bhs&chco=#{chco}&chm=#{chm}&chds=0,10&chxt=y&chdl=#{chdl}&chxl=#{chxl}&chxr=#{chxr}&chxs=#{chxs}"    
    end
    link
  end
  
  def n(value)
    if value == nil
      return 0
    else
      return value
    end
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
    
    @fuels = Car.all.map(&:fuel).uniq.sort.collect{|p| [p]}
    @years = Car.all.map(&:year).uniq.sort.collect{|p| p}
    
    @states = State.all(:order=>:name)
    if params[:st]
      @service_filter.service_type_id = ServiceType.find(params[:st]).id
    end
    
    @company_services = company_services(current_user.company.id)
    @brands = Brand.all(:order=>:name)
    
    @models  = Array.new
    if @service_filter.brand_id
      @models = Model.find_all_by_brand_id(@service_filter.brand_id,:order=>:name)
    end
    
    conditions = {}
    conditions.merge!({"service_type_id" =>  @service_filter.service_type_id}) if  @service_filter.service_type_id
    conditions.merge!({"cars.brand_id" => @service_filter.brand_id}) if @service_filter.brand_id
    conditions.merge!({"cars.model_id" => @service_filter.model_id}) if @service_filter.model_id
    conditions.merge!({"cars.fuel" => @service_filter.fuel}) unless @service_filter.fuel.blank?
    conditions.merge!({"cars.year" => @service_filter.year}) if @service_filter.year
    
    conditions.merge!({"addresses.state_id" => @service_filter.state_id}) if @service_filter.state_id?
    conditions.merge!({"addresses.city" => @service_filter.city}) if @service_filter.city?
    
    @red_cars = Event.red.all(:conditions => conditions, :include => {:car =>[:user =>:address]})
    @yellow_cars = Event.yellow.all(:conditions => conditions, :include => {:car =>[:user =>:address]})
    @green_cars = Event.green.all(:conditions => conditions, :include => {:car =>[:user =>:address]})
    
    @events = @red_cars + @yellow_cars + @green_cars
    current_page = params[:page] || 1
    per_page=10
    logger.info "###   #{current_page}"
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
    @models = Model.find_all_by_brand_id(params[:brand_id])
    respond_to do |format|
      format.js
    end
  end
end
