class Workorder < ActiveRecord::Base
  has_many :services, :dependent => :destroy
  belongs_to :car
  belongs_to :company
  belongs_to :user
  has_many :ranks
  
  def type(type)
    ranks.select{|r| r.type_rank == type}.first
  end  
  
  def user_rank
    type 1
  end  
  
  def company_rank
    type 2
  end
  
  def after_initialize
    self.performed = I18n.l(Time.now.to_date) unless performed
    self.status = Status.open unless status
  end  
  
  
  accepts_nested_attributes_for :services,:reject_if => lambda { |a| a[:service_type_id].blank? }, :allow_destroy => true
  #validates_presence_of :services
  
  before_save :set_status
  
  validate :service_not_empty
  
  def service_not_empty
    if services.size == 0
      errors.add_to_base("La orden de trabajo debe contener servicios")      
    end
  end
  
  def total_price
    s_total_price=0
    self.services.each do |s|
      s_total_price += s.total_price if s.status != Status.cancel  
    end   
    s_total_price
  end
  
  def detail
    str=""
    services.each do |s|
      str += s.service_type.name
    end
    str
  end
  
  def generate_events
    services.each do |service| 
      unless service.cancelled
        delete_event service
        create_event service  
      end
    end
    update_event_status
  end
  
  def set_status
    open = services.select{|s| s.status == Status.open || s.status == Status.in_progress}
    
    if (open.size > 0 || services.size ==0)
      self.status = Status.open
    else
      self.status = Status.finish
    end
  end
  
  def finish?
    status == Status.finish
  end
  
  def open?
    status == Status.open
  end
  
  def belong_to_user user
    user.cars.include?(car)
  end
  
  private
  def create_event service
    service_type = service.service_type
    months = (service_type.kms / car.kmAverageMonthly).to_i
    event = Event.new
    event.car = self.car
    event.km = self.car.km + service_type.kms
    event.service_type=service_type
    event.service = service
    event.status= Status::ACTIVE
    event.dueDate = months.month.since
    event.save
  end
  
  def update_event_status
    services.each do |service| 
      unless service.cancelled
        events_r = Event.red.car(service.workorder.car.id).service_typed(service.service_type.id).map.each{|e| e.id}
        events = events_r + Event.yellow.car(service.workorder.car.id).service_typed(service.service_type.id).map.each{|e|e.id}
        events.each do |id|
          e = Event.find id
          unless e.service.workorder.id == service.workorder.id
            e.status = Status.finish
            e.service_done = service
            e.save
          end
        end
      end
    end
  end
  
  def delete_event service
    events = Event.green.car(service.workorder.car.id).service_typed(service.service_type.id)
    events.each do |e|
      e.destroy
    end
  end
  
  def self.find_by_params(filters)
    
    domain =  filters[:domain] || ""
    
    @workorders= Workorder.joins(:car).where("cars.domain like ?","%#{domain.upcase}%")
    
    if ((!filters[:date_from].nil?) && (!filters[:date_to].nil?))
      date_f = filters[:date_from].to_datetime
      date_t = filters[:date_to].to_datetime.since 1.day
      @workorders = @workorders.where("performed between ? and ? ",date_f.in_time_zone,date_t.in_time_zone)
    end
    
    if filters[:date_from].nil? && (!filters[:date_to].nil?)
      date_from = filters[:date_to].to_datetime.since 1.day
      @workorders = @workorders.where("performed <= ? ",date_from.in_time_zone)
    end  
    
    if ((!filters[:date_from].nil?) && (filters[:date_to].nil?))
      date_from = filters[:date_from].to_datetime
      @workorders = @workorders.where("performed >= ? ",date_from.in_time_zone)
    end 

    if filters[:service_type_id]
      @workorders = @workorders.includes(:services).where("services.service_type_id = ?",filters[:service_type_id])
    end
    
    if filters[:user].company
      @workorders = @workorders.where("workorders.company_id = ?",filters[:user].company.id)
    else
      @workorders = @workorders.where("car_id in (?)",filters[:user].cars.map{|c| c.id})
    end

    @workorders
  end
     
  
end
