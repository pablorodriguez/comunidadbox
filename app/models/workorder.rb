class Workorder < ActiveRecord::Base
  has_many :services, :dependent => :destroy
  belongs_to :car
  belongs_to :company
  belongs_to :user
  belongs_to :payment_method
  has_many :ranks
  accepts_nested_attributes_for :services,:reject_if => lambda { |a| a[:service_type_id].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :payment_method
  validate :service_not_empty
  
  before_save :set_status
  after_initialize :init
  
  def type(type)
    ranks.select{|r| r.type_rank == type}.first
  end  
  
  def user_rank
    type 1
  end  
  
  def company_rank
    type 2
  end
  
  def init
    unless self.id
      self.performed = I18n.l(Time.now.to_date) 
      self.status = Status::OPEN 
      self.payment_method = PaymentMethod.find 1       
    end
  end
  
  def service_not_empty
    if services.size == 0
      errors.add_to_base("La orden de trabajo debe contener servicios")      
    end
  end
  
  def find_car_service_offer(company_id,status= Status::CONFIRMED)
    car_service_offer = CarServiceOffer.cars(car.id).company(company_id).by_status(status)
    car_service_offer.each do |cso|
      service = services.select{|s| s.service_type.id == cso.service_offer.service_type.id}.first
      service.car_service_offer = cso if service
    end
    car_service_offer
  end
  
  def car_service_offers
    services.map{|s| s.car_service_offer}.delete_if{|cso| cso == nil}
  end
  
  def total_price
    s_total_price=0
    self.services.each do |s|
      s_total_price += s.total_price if s.status != Status::CANCELLED  
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
    in_progress = services.select{|s| s.status == Status::IN_PROCESS}
    if (in_progress.size > 0)
      self.status = Status::IN_PROCESS
      return
    end
    
    open = services.select{|s| s.status == Status::OPEN}    
    if (open.size > 0)
      self.status = Status::OPEN
      return  
    end
    
    self.status = Status::FINISHED
    
  end
  
  def finish?
    status == Status::FINISHED
  end
   
  def open?
    status == Status::OPEN
  end

  def in_progress?
    status == Status::IN_PROCESS
  end
  
  def belong_to_user user
    user.cars.include?(car)
  end
  
  def can_edit?(user)
    if (company == user.company && company.is_employee(self.user) && (open? || in_progress?))
      return true
    else
      return false   
    end
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
        events_r = Event.red.car(service.workorder.car.id).service_typed(service.service_type.id).map(&:id)
        events = events_r + Event.yellow.car(service.workorder.car.id).service_typed(service.service_type.id).map(&:id)
        events.each do |id|
          e = Event.find id
          unless e.service.workorder.id == service.workorder.id
            e.status = Status::FINISHED
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
    @workorders =@workorders.includes(:services => :material_services)
    
    if ((!filters[:date_from].empty?) && (!filters[:date_to].empty?))
      date_f = filters[:date_from].to_datetime
      date_t = filters[:date_to].to_datetime.since 1.day
      @workorders = @workorders.where("performed between ? and ? ",date_f.in_time_zone,date_t.in_time_zone)
    end
    
    if filters[:date_from].empty? && (!filters[:date_to].empty?)
      date_from = filters[:date_to].to_datetime.since 1.day
      @workorders = @workorders.where("performed <= ? ",date_from.in_time_zone)
    end  
    
    if ((!filters[:date_from].empty?) && (filters[:date_to].empty?))
      date_from = filters[:date_from].to_datetime
      @workorders = @workorders.where("performed >= ? ",date_from.in_time_zone)
    end 
    
    if filters[:user].company
      @workorders = @workorders.where("workorders.company_id = ?",filters[:user].company.id)
    else
      @workorders = @workorders.where("car_id in (?)",filters[:user].cars.map{|c| c.id})
    end

    unless filters[:wo_status_id].empty?
      @workorders = @workorders.where("workorders.status = ?", filters[:wo_status_id])
    end
    
    unless filters[:service_type_id].empty?
      @workorders = @workorders.where("services.service_type_id = ?",filters[:service_type_id])
    end
    
    @workorders
  end
  
end
