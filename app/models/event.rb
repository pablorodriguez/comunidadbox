class Event < ActiveRecord::Base
  belongs_to :service_type
  belongs_to :car
  belongs_to :service
  belongs_to :service_done,:class_name =>"Service"

  MONTHS_IN_SEC = 60 * 60 * 24 * 30
  MONTH_RED=1
  MONTH_YELLOW=2
  MONTH_GREEN=2
 
  scope :red, lambda {{:conditions => ["dueDate <= ? AND events.status = ?", Time.now.months_since(Event::MONTH_RED),Status::ACTIVE]}}
  scope :yellow, lambda {{:conditions => ["dueDate > ? AND dueDate <= ?",Time.now.months_since(Event::MONTH_RED), Time.now.months_since(Event::MONTH_YELLOW)]} }
  scope :green, lambda {{:conditions => ["dueDate > ? ",Time.now.months_since(Event::MONTH_GREEN)]} }

  scope :modeled, lambda { |model| { :joins => :car, :conditions =>  ["cars.model_id = ?", model] } }
  scope :branded, lambda { |brand| { :joins => :car, :conditions =>  ["cars.brand_id = ?", brand] } }
  scope :yeared, lambda { |year| { :joins => :car, :conditions => ["cars.year = ?", year] } }
  scope :fueled, lambda { |fuel| { :joins => :car, :conditions => ["cars.fuel = ?", fuel] } }
  scope :service_typed, lambda { |service_type| { :conditions => ["service_type_id = ?", service_type] } }
  scope :work_ordered,lambda{|work_order_id|{:joins =>[:service =>:workorder],:conditions =>["workorders.id = ?",work_order_id]}}
  scope :car,lambda{|car_id| {:joins=>:car,:conditions =>["cars.id = ?",car_id]}}
  scope :active, lambda { {:conditions =>  ["status = ?", Status::ACTIVE]}}
  scope :future, lambda { |day| {:conditions =>  ["dueDate >= ?", day]}}
  
  def is_green
    dueDate > Time.now.months_since(Event::MONTH_YELLOW).to_date ? true : false
  end
  
  def is_yellow
    dueDate > Time.now.months_since(Event::MONTH_RED).to_date && dueDate <= Time.now.months_since(Event::MONTH_YELLOW).to_date ? true : false
  end
  
  def is_red
    dueDate <= Time.now.months_since(Event::MONTH_RED).to_date ? true : false 
  end
  
  def self.find_by_params(service_filter,event_types,my_clients=true,others=true,company_id=nil)
    events = Event.includes(:car => {:user => :address},:service =>{:workorder =>:company}).order("cars.domain")
    events = events.where("events.status = ?",Status::ACTIVE)
    events = events.where("events.service_type_id = ?",service_filter.service_type_id) if  service_filter.service_type_id
    if service_filter.brand_id
      events = events.includes(:brand)
      events = events.where("cars.brand_id = ?",service_filter.brand_id)  
    end
    
    if service_filter.model_id
      events = events.includes(:model)
      events = events.where("cars.model_id = ?",service_filter.model_id)        
    end
    
    logger.debug "### company id #{company_id} #{my_clients}"    
    if my_clients    
      events = events.where("workorders.company_id = ?",company_id)
    end
    
    logger.debug "### company id #{company_id} #{others}"
    if others
      events = events.where("workorders.company_id != ?",company_id)
    end
     
    events = events.where("cars.fuel = ? ",service_filter.fuel) unless service_filter.fuel.blank?
    events = events.where("cars.year = ?",service_filter.year) if service_filter.year
    events = events.where("addresses.state_id = ?",service_filter.state_id) if service_filter.state_id?
    events = events.where("addresses.city = ? ",service_filter.city) if service_filter.city?

    totalEvents = []
  
    totalEvents = events.red if event_types[:red]
    totalEvents += events.yellow if event_types[:yellow]
    totalEvents += events.green if event_types[:green]
    
    totalEvents  
  end

end
