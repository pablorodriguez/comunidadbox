include ActionView::Helpers::NumberHelper

class Workorder < ActiveRecord::Base
  attr_accessible  :budget_id, :car_id, :company_id, :company_info, :performed, :payment_method_id, :comment, :services_attributes, :notes_attributes,:deliver,:deliver_actual,:user_id
  
  include Statused  

  ORDER_BY = {"-- Ordenar por ---" =>"workorders.performed desc","Dominio: Descendiente"=>"cars.domain desc","Dominio: Ascendiente"=>"cars.domain asc",
    "Realizado: Descendiente"=>"workorders.performed desc","Realizado: Ascendiente" => "workorders.performed asc"}
    
  has_many :services, :dependent => :destroy,:inverse_of => :workorder
  has_many :notes,:dependent => :destroy
  belongs_to :car
  belongs_to :company
  belongs_to :user  
  belongs_to :budget
  belongs_to :payment_method
  has_many :ranks
  accepts_nested_attributes_for :services,:reject_if => lambda { |a| a[:service_type_id].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :payment_method
  accepts_nested_attributes_for :notes,:reject_if => lambda { |a| a[:message].blank? }, :allow_destroy => true
  #validates :services ,:length =>{:minimum => 1}
  #validates_presence_of :deliver, :message => "Debe ingresar una hora de entrega"
  validates_presence_of :performed, :message =>"Debe ingresar una fecha de realizado"
  

  #,:message =>"La orden de trabajo debe contener servicios"
  validate :validate_all

  scope :for_car, lambda { |car_id| { :conditions =>  ["car_id = ?", car_id] ,:order => "performed desc"} }
  
  before_save :before_save_call_back
  after_save :to_after_save
  after_initialize :init

  normalize_attributes :comment

  def before_save_call_back
    set_status
    set_company_client
  end

  def set_company_client
    car = self.car
    unless car.user.service_centers.map(&:id).include?(self.company_id)
      comp = Company.find_by_id(self.company_id)
      car.user.service_centers << comp if comp
    end
  end

  def to_after_save
    if is_finished?
      regenerate_events
      send_notification
      update_car_service_offers
    end
  end

  def update_car_service_offers
    CarServiceOffer.update_with_services(self.services)
  end

  def type(type)
    #select{|r| r.type_rank == type}.first
    ranks.where("type_rank = ?",type).first
  end
  
  def company_name
    return company.name if company
    return company_info if company_info
    return ""
  end  
  
  def user_rank
    type Rank::USER
  end  
  
  def company_rank
    type Rank::COMPANY
  end

  # inicializo uan orden de trabajo con ofertas de servicios realizados
  def initialize_with_car_service_offer companies_ids
    if car
      car_services_offers =  car.search_service_offer(companies_ids)

      car_services_offers.each do |car_service_offer|
        car_service_offer.service_offer.service_types.each do |st|

          prev_service = self.services.find{|s| s.service_type_id == st.id}

          if prev_service
            prev_service.today_car_service_offer << car_service_offer
          else
            new_service = Service.new(service_type_id: st.id,car_service_offer_id: car_service_offer.id)
            new_service.car_service_offer = car_service_offer
            new_service.today_car_service_offer << car_service_offer
            new_service.material_services << MaterialService.new(amount: 1,price: 0)
            self.services << new_service
          end
        end
      end
    end
  end
  
  # inizializo una orden de trabajo con un budget
  def initialize_with_budget n_budget
    self.car = n_budget.car
    self.budget = n_budget
    n_budget.services.each do |s|
      
      n_s = Service.new(service_type_id: s.service_type_id)
      s.material_services.each do |ms|
        new_m_s= MaterialService.new
        new_m_s.amount = ms.amount
        new_m_s.price = ms.price
        new_m_s.material_service_type_id = ms.material_service_type_id
        new_m_s.material = ms.material

        n_s.material_services << new_m_s
        
      end 
      self.services << n_s        
    end
  end
  
  def init  
    if self.performed.nil?
      self.performed = I18n.l(Time.zone.now.to_date)       
    else
      logger.debug "########################  no inicializo performed #{self.performed}"
    end

    self.status = Status::OPEN unless self.status

    self.payment_method = PaymentMethod.find_by_name("Efectivo") unless self.payment_method  

  end
  
  def validate_all
    logger.debug "####### entro a validate all #{self.services}"
    if self.services.empty?
      errors[:services] << "La orden de trabajo debe contener servicios"
      logger.debug "############################# service esta vacio"
    end

    if self.user.company
      unless deliver
        errors[:deliver] << "no puede ser vacio"
      end
      unless user.company.is_employee?(user)
        errors[:services] << "El prestador de servicios es incorrecto"
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
          e.destroy
        end
      end
      generate_events
    end
    
  end
  
  def set_status
    n_status = Status::FINISHED
    self.services.each do |s|      
      if ((s.status == Status::IN_PROCESS || s.status == Status::OPEN) && (!(s._destroy)))
        n_status = Status::OPEN
      end
    end

    n_status = Status::OPEN if self.services.empty?    
    self.status = n_status    
  end
  
  def finish_old?
    status == Status::FINISHED
  end
   
  def open_old?
    status == Status::OPEN
  end

  def in_progress_old?
    status == Status::IN_PROCESS
  end

  def belong_to_user user
    user.cars.include?(car)
  end

  def can_show_pdf? user
    car.user == user
  end

  def can_print_pdf? user
    can_show? user
  end

  def can_send_message?(usr)
    car.user.id != usr.id
  end

  def can_rank? user
    car.user == user || (company && company.is_employee?(user))
  end

  def can_delete?(usr)
    if ((user.id == usr.id) && usr.is_car_owner?)
      return true
    end

    can_edit?(usr)

  end
  
  def can_edit?(usr)
    if ((user.id == usr.id) && user.is_car_owner?)
      return true
    end

    if (is_open? || is_in_progress?)
      if company.is_employee?(usr) && user.is_employee?
        return true
      end
    end
    return false
  end

  def can_show?(usr)
    # si el usuario de la orden de trabajo es el dueno del auto
    return true if usr.own_car(car)    

    # si el usuario de la orden de trabajo es igual al usuario 
    return true if (self.user.id == usr.id)

    # si el usuario pertenece a la compania donde se realizo la worden de trabajo
    return true if (company && usr.belongs_to_company(company))

    # si el usuario es manager o empleado y pertenece a algunas de las sucursales
    # del prestador de servicios
    return true if ((usr.is_manager? || usr.is_employee?) && (company && company.user.belongs_to_company(usr.company)))

    # otra cosa no lo puede ver
    return false
  end
  
  
  def create_event service
    service_type = service.service_type
    if service_type.kms > 0
      months = (service_type.kms / car.kmAverageMonthly.to_f).round.to_i
      newDueDate = (service.workorder.performed + months.month)
    elsif service_type.days > 0
      newDueDate = service_type.days.days.since
    end
    event = service.events.build(car: self.car,km: (self.car.km + service_type.kms),
      service_type: service_type,status: (Status::ACTIVE),dueDate: newDueDate)

    #event.car = self.car
    #event.km = self.car.km + service_type.kms
    #event.service_type=service_type
    #event.service = service
    #event.status= Status::ACTIVE
    #event.dueDate = service.workorder.performed + months.month
    logger.debug "### Event created DueDate: #{event.dueDate} Service Performed: #{service.workorder.performed} Months: #{months} Service #{event.service_id}"
    event
  end
  
  def send_notification
    logger.info "### envio de notificacion mail #{self.id} Car: #{self.car.domain}"
    #message = WorkOrderNotifier.notify(work_order).deliver
    Resque.enqueue WorkorderJob,self.id
  end

  
  def delete_event service
    logger.debug "### #{service.id} #{service.workorder}"
    events = Event.green.car(service.workorder.car.id).service_typed(service.service_type.id)
    events.each do |e|
      e.status = Status::CANCELLED
      e.save
    end
  end
  
  def self.build_material_data(amount_data,count_data)
    total_amount = 0
    amount_data.values.each{|v| total_amount += v.to_f}
    data_detail = {}
    amount_data.each do |key,amount|
      percentage = ((amount.to_f * 100) / total_amount)
      if key.nil?
        new_key = "Otro"
      else
        new_key = Material.find(key).name
      end
      count = count_data[key]
      data_detail[new_key] = [amount,percentage,count]
    end
    data_detail
  end

  def self.build_graph_data(data,class_name=ServiceType)
    data_str =""

    total = 0    
    data.values.each{|v| total += v.to_f}

    data.each do |key,value|
      if (key && total > 0)
        percentage = ((value.to_f * 100) / total)

          entity = "Otro"
          entity = class_name.send(:find,key) if key
          data_str = data_str + "{ 
            name: '#{entity.name}', 
            p: #{number_with_precision(value,:precision=>2,:separator=>".",:delimiter=>"")},
            y: #{number_with_precision(percentage,:precision=>2,:separator=>".",:delimiter=>"")},
            },"
            #color: '#{GraphColor.color(key)}'},
        
      end
    end
    data_str.chop
  end

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |workorder|
        csv << workorder.attributes.values_at(*column_names)
      end
    end
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
  
  def self.group_by_material(params,price=true)
    wo = self.find_by_params(params)
    wo = wo.group("material_service_types.material_id")
    if price
      wo = wo.sum("amount * price")
    else
      wo = wo.sum("material_services.amount")
    end        
    wo
  end
  

  def self.find_by_params(filters)
    workorders = Workorder.order(filters[:order_by]).includes(:payment_method,:company,:car =>:user,:services => [{:material_services => [{:material_service_type =>:service_type}]}])
    
    workorders = workorders.where("cars.domain like ?","%#{filters[:domain].upcase}%") if filters[:domain]

    #workorders = workorders.order("service_types.name")
    
    workorders = workorders.where("workorders.car_id IN (?)", filters[:user].cars.map(&:id)) if filters[:user] && filters[:user].company.nil?
    
    workorders = workorders.where("performed between ? and ? ",filters[:date_from].to_datetime.in_time_zone,filters[:date_to].to_datetime.in_time_zone) if (filters[:date_from] && filters[:date_to])
    
    workorders = workorders.where("performed <= ? ",filters[:date_to].to_datetime.in_time_zone) if ((filters[:date_from] == nil) && filters[:date_to])
    workorders = workorders.where("performed >= ? ",filters[:date_from].to_datetime.in_time_zone) if (filters[:date_from] && (filters[:date_to] == nil))
    
    workorders = workorders.where("workorders.company_id IN (?)",filters[:company_id]) if filters[:company_id]
    
    #workorders = workorders.where("car_id in (?)",filters[:user].cars.map{|c| c.id})
    
    workorders = workorders.where("workorders.id = ?", filters[:workorder_id]) if filters[:workorder_id]
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
        #logger.debug "### #{e.service.workorder.id} #{service.workorder.id}"
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

  def build_rank_for_user(user)
    rank = self.ranks.build
    rank.cal=0
    rank.type_rank = Rank.rank_type(user) 
    if company_rank && user.company
      rank = company_rank
    elsif user_rank && (user.company.nil?)
      rank = user_rank
    end
    rank
  end


end
