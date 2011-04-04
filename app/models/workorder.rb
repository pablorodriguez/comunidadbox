class Workorder < ActiveRecord::Base
  has_many :services, :dependent => :destroy
  belongs_to :car
  belongs_to :company
  belongs_to :user
  belongs_to :user_rank, :class_name => 'Rank',:foreign_key => 'user_rank_id'
  belongs_to :company_rank,:class_name =>'Rank', :foreign_key => 'company_rank_id'

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
      s_total_price += s.total_price if s.status != "Cancelado"  
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
    open = services.select{|s| s.status == "Abierto" || s.status == "En Proceso"}
    
    if (open.size > 0 || services.size ==0)
      self.status = "Abierto"
    else
      self.status = "Terminado"
    end
  end
  
  def finish?
    status == "Terminado"
  end
  
  def open?
    status == "Abierto"
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
    event.status="Activa"
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
            e.status ="Completado"
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
  
  
end
