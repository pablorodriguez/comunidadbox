class Event < ActiveRecord::Base
  belongs_to :service_type
  belongs_to :car
  belongs_to :service, :inverse_of => :events

  belongs_to :service_done,:class_name =>"Service"
  has_many :notes
  has_many :alarms

  MONTHS_IN_SEC = 60 * 60 * 24 * 30
  MONTH_RED=1
  MONTH_YELLOW=2
  MONTH_GREEN=2
 
  scope :red, lambda {{:conditions => ["dueDate <= ? AND dueDate >= ? AND events.status = ?", 
    Time.now.months_since(Event::MONTH_RED),Time.now.months_ago(Event::MONTH_RED),Status::ACTIVE]}}
  scope :yellow, lambda {{:conditions => ["dueDate > ? AND dueDate <= ?",Time.now.months_since(Event::MONTH_RED), Time.now.months_since(Event::MONTH_YELLOW)]} }
  scope :green, lambda {{:conditions => ["dueDate > ? ",Time.now.months_since(Event::MONTH_GREEN)]} }

  scope :modeled, lambda { |model| { :joins => :car, :conditions =>  ["cars.model_id = ?", model] } }
  scope :branded, lambda { |brand| { :joins => :car, :conditions =>  ["cars.brand_id = ?", brand] } }
  scope :yeared, lambda { |year| { :joins => :car, :conditions => ["cars.year = ?", year] } }
  scope :fueled, lambda { |fuel| { :joins => :car, :conditions => ["cars.fuel = ?", fuel] } }
  scope :service_typed, lambda { |service_type| { :conditions => ["service_type_id = ?", service_type] } }
  scope :not_service_typed, lambda { |service_type| { :conditions => ["events.service_type_id != ?", service_type] } }
  scope :work_ordered,lambda{|work_order_id|{:joins =>[:service =>:workorder],:conditions =>["workorders.id = ?",work_order_id]}}
  scope :car,lambda{|car_id| {:joins=>:car,:conditions =>["cars.id = ?",car_id]}}
  scope :active, lambda { {:conditions =>  ["status = ?", Status::ACTIVE]}}
  scope :future, lambda { |day| {:conditions =>  ["dueDate >= ?", day]}}
  
  def is_green
    dueDate > Time.now.months_since(Event::MONTH_YELLOW).to_date ? true : false
  end

  def belongs_to_company company
    service.workorder.company.id == company.id
  end
  
  def is_yellow
    dueDate > Time.now.months_since(Event::MONTH_RED).to_date && dueDate <= Time.now.months_since(Event::MONTH_YELLOW).to_date ? true : false
  end
  
  def is_red
    dueDate <= Time.now.months_since(Event::MONTH_RED).to_date ? true : false 
  end

  def self.group_by(service_type_id=nil)
    events = Event.includes("service")
    events = events.where("services.service_type_id != ?",service_type_id) if service_type_id
    events = events.red.select("car_id,services.service_type_id").group("car_id,services.service_type_id").order(:car_id)
    events
  end

  def self.other_events service_type_id,company_id=nil,other=true
    events = {}
    e = Event.not_service_typed(service_type_id).group("events.car_id,events.service_type_id")
    e = e.includes(:service=>{:workorder =>:company}).where("workorders.company_id = ?",company_id) if (company_id && other)
    e = e.includes(:service=>{:workorder =>:company}).where("workorders.company_id != ?",company_id) if (company_id && !(other))

    e.each do |e|
      st = events[e.car_id]
      if st
        if (st.class.to_s  == "Fixnum")
          sts =[]          
          sts << st
          sts << e.service_type_id
          events[e.car_id] = sts
        else
          st << e.service_type_id          
        end
      else  
        events[e.car_id] = e.service_type_id  
      end
    end
    events
  end
  
  def self.find_by_params(service_filter,event_types,my_clients=true,others=true,company_id=nil)
    events = Event.includes(:car => {:user => :address},:service =>{:workorder =>[:payment_method,:company]}).order("events.dueDate desc")
    events = events.where("events.status = ?",Status::ACTIVE)    
    events = events.where("events.service_type_id = ?",service_filter.service_type_id) if  service_filter.service_type_id

    if service_filter.brand_id
      events = events.where("cars.brand_id = ?",service_filter.brand_id)  
    end
    
    if service_filter.model_id
      events = events.where("cars.model_id = ?",service_filter.model_id)        
    end
    
    if (my_clients && !(others))
      events = events.where("workorders.company_id in (?)",company_id)
    end
    
    if (others && !(my_clients))
      events = events.where("workorders.company_id  not in (?)",company_id)
    end
     
    events = events.where("cars.fuel = ? ",service_filter.fuel) unless service_filter.fuel.blank?
    events = events.where("cars.year = ?",service_filter.year) if service_filter.year
    events = events.where("addresses.state_id = ?",service_filter.state_id) if service_filter.state_id?
    events = events.where("addresses.city = ? ",service_filter.city) if service_filter.city?
    events = events.group("events.car_id").group("services.service_type_id")

    totalEvents = []

    if ((service_filter.date_from && service_filter.date_to) &&
          (!service_filter.date_from.empty? && !service_filter.date_to.empty?))
      events = events.where("dueDate between ? and ?",service_filter.date_from.to_datetime.in_time_zone,service_filter.date_to.to_datetime.in_time_zone)
      totalEvents = events
    else
      totalEvents = events.red if event_types[:red]
      totalEvents += events.yellow if event_types[:yellow]
      totalEvents += events.green if event_types[:green]  
    end    
    
    totalEvents  
  end

  def notes_txt
    self.notes.map(&:message).join(" | ");
  end

end
