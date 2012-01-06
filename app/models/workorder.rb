class Workorder < ActiveRecord::Base

  include ActionView::Helpers::NumberHelper
    
  has_many :services, :dependent => :destroy
  has_many :notes,:dependent => :destroy
  belongs_to :car
  belongs_to :company
  belongs_to :user  
  belongs_to :budget
  belongs_to :payment_method
  has_many :ranks
  accepts_nested_attributes_for :services,:reject_if => lambda { |a| a[:service_type_id].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :payment_method
  
  validate :validate_all
  
  before_save :set_status
  after_initialize :init

  normalize_attributes :comment


  def type(type)
    ranks.select{|r| r.type_rank == type}.first
  end
  
  def company_name
    return company.name if company
    return company_info if company_info
    return ""
  end  
  
  def user_rank
    type 1
  end  
  
  def company_rank
    type 2
  end

  # inizializo una orden de trabajo con un budget
  def initialize_with_budget n_budget
    self.car = n_budget.car
    self.budget = n_budget
    n_budget.services.each do |s|
      n_s = s.clone  
      s.material_services.each do |ms|
        n_s.material_services << ms.clone
      end 
      self.services << n_s        
    end
  end
  
  def init  
    if self.attributes.has_key?('performed')
      self.performed = I18n.l(Time.now.to_date) unless self.performed  
    end
    
    if self.attributes.has_key?('status')
      self.status = Status::OPEN unless self.status  
    end
          
    self.payment_method = PaymentMethod.find 1 unless self.payment_method        
  end
  
  def validate_all
    if services.size == 0
      errors.add_to_base("La orden de trabajo debe contener servicios")      
    end

    if user.company
      unless user.company.is_employee(user)
        errors.add_to_base("El prestador de servicios es incorrecto")
      end

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
    if (self.car.kmAverageMonthly && (self.car.kmAverageMonthly > 0))
      services.each do |service| 
        unless service.cancelled
          new_event = create_event(service)
          
          #busco evento a futuro para el mismo tipo de servicio, me quedo con el ultimo realizado
          service_future = Service.find_future(service).last
          if service_future
            logger.debug "### Encontro servicio futuro #{service_future.id}"
            # si hay , cancelo el evento con el servicio a futuro realizado
            new_event.status =Status::CANCELLED
            new_event.service_done = service_future
            #grabo el evento en la base de datos y no hago nada mas
            new_event.save          
          else
            # si no hay servicios del mismo tipo en el futuro
            # busco los eventos y actualizo su estado a CANCELLED por este nuevo servicio
            #actualizo el estado de eventos futuros o pasados
            Workorder.update_event_status service
            #grabo el evento en la base de datos
            new_event.save
          end
        end
      end
    end
  end
  
  def regenerate_events
    Event.transaction do
      services.each do |service|        
        service.events.each do |e|
          logger.debug "### Borro evento #{e.id} service #{service.id}" 
          e.destroy
        end
      end
      generate_events
    end
    
  end
  
  def set_status
    n_status = Status::FINISHED
    self.services.each do |s|
      logger.debug "### Status #{s.status} Destroy #{s._destroy}"
      if ((s.status == Status::IN_PROCESS || s.status == Status::OPEN) && (!(s._destroy)))
        n_status = Status::OPEN
      end
    end
    logger.debug "### New Status #{n_status}"
    self.status = n_status    
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
  
  def can_edit?(usr)
    if ((company.is_employee(usr)) && (open? || in_progress?))
      return true
    else
      return false   
    end
  end

  def can_show?(user)
    return true if user.own_car(car)
    return true if (self.user == user)
    return true if user.belongs_to_company(company)
    return false
  end
  
  private
  def create_event service
    service_type = service.service_type
    months = (service_type.kms / car.kmAverageMonthly.to_f).round.to_i
    event = Event.new
    event.car = self.car
    event.km = self.car.km + service_type.kms
    event.service_type=service_type
    event.service = service
    event.status= Status::ACTIVE
    event.dueDate = service.workorder.performed + months.month
    logger.debug "### Event created DueDate: #{event.dueDate} Service Performed: #{service.workorder.performed} Months: #{months} Service #{event.service_id}"
    event
  end
  
  
  def delete_event service
    logger.debug "### #{service.id} #{service.workorder}"
    events = Event.green.car(service.workorder.car.id).service_typed(service.service_type.id)
    events.each do |e|
      e.status = Status::CANCELLED
      e.save
    end
  end
  
  def self.build_graph_data service_data
    data_str =""
    total = 0 
    service_data.values.each{|v| total = total + v.to_f}
    service_data.each do |key,value|
      if (key && total > 0)
        percentage = ((value.to_f * 100) / total)
        service_type = ServiceType.find(key)
        logger.debug "### Key: #{key}, Value: #{value} #{service_type.name} %: #{percentage} total: #{total}"
        data_str = data_str + "{ 
          name: '#{service_type.name}', 
          y: #{number_with_precision(value,:precision=>2,:separator=>".",:delimiter=>"")},
          p: #{number_with_precision(percentage,:precision=>2,:separator=>".",:delimiter=>"")},
          color: '#{service_type.color}' },"        
      end
    end
    data_str.chop
  end
  
  def self.group_by_service_type(params,price=true)
    wo = self.find_by_params(params)
    wo = wo.group("services.service_type_id")
    if price
      wo = wo.sum("amount * price")
    else
      wo = wo.count("services.id")
    end    
    wo
  end
  
  def self.find_by_params(filters)
    
    domain =  filters[:domain] || ""
    
    workorders = Workorder.includes([:company,:payment_method],:car =>:user).where("cars.domain like ?","%#{domain.upcase}%")
    workorders = workorders.includes(:services => {:material_services =>{:material_service_type =>:service_type}})
    #workorders = workorders.order("service_types.name")
    if filters[:user] && filters[:user].company.nil?
      workorders = workorders.where("workorders.car_id IN (?)", filters[:user].cars.map(&:id))
    end
    
    workorders = workorders.where("performed between ? and ? ",filters[:date_from].to_datetime.in_time_zone,filters[:date_to].to_datetime.in_time_zone) if (filters[:date_from] && filters[:date_to])
    
    workorders = workorders.where("performed <= ? ",filters[:date_to].to_datetime.in_time_zone) if ((filters[:date_from] == nil) && filters[:date_to])
    workorders = workorders.where("performed >= ? ",filters[:date_from].to_datetime.in_time_zone) if (filters[:date_from] && (filters[:date_to] == nil))
    
    if filters[:company_id]
      workorders = workorders.where("workorders.company_id = ?",filters[:company_id])
    else
      #workorders = workorders.where("car_id in (?)",filters[:user].cars.map{|c| c.id})
    end

    workorders = workorders.where("workorders.status = ?", filters[:wo_status_id]) if filters[:wo_status_id]
    
    workorders = workorders.where("services.service_type_id IN (?)",filters[:service_type_ids]) if filters[:service_type_ids]
    logger.debug "### Filters SQL #{workorders.to_sql}"
    workorders
  end
  
  def self.update_event_status service
    unless service.cancelled
      #busco los servicios rojos y amarillos
      events =  Event.car(service.workorder.car.id).service_typed(service.service_type.id).active.map(&:id)
      events.each do |id|
        
        e = Event.find id
        # Valido que el evento no pertenezca a la misma Workorder
        logger.debug "### #{e.service.workorder.id} #{service.workorder.id}"
        if e.service.workorder.id != service.workorder.id
          logger.debug "### encontro eventos futuros para cancelar con este nuevo creado #{e.id}"
          #cambio su esado a finished
          e.status = Status::CANCELLED
          #seteo cual fuel el servicio que cancelo este evento 
          e.service_done = service
          e.save
        end
      end
    end
  end


end
