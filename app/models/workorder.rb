# encoding: utf-8
include ActionView::Helpers::NumberHelper

class Workorder < ActiveRecord::Base
  acts_as_paranoid

  attr_accessible  :budget_id, :car_id, :company_id, :company_info, :performed, :payment_method_id, :comment, :services_attributes, :notes_attributes,:deliver,:deliver_actual,:user_id,:status_id,:vehicle_id

  ORDER_BY = {I18n.t("order_by") =>"workorders.performed desc",I18n.t("domain_descendant")=>"vehicles.domain desc",I18n.t("domain_ascendant")=>"vehicles.domain asc",
   I18n.t("done_descendant")=>"workorders.performed desc",I18n.t("done_ascendant") => "workorders.performed asc"}

  has_many :services, :dependent => :destroy,:inverse_of => :workorder
  has_many :notes,:dependent => :destroy
  belongs_to :vehicle
  belongs_to :company
  belongs_to :user
  belongs_to :budget
  belongs_to :payment_method
  belongs_to :status
  has_many :ranks
  has_many :price_offers

  accepts_nested_attributes_for :services,:reject_if => lambda { |a| a[:service_type_id].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :payment_method
  accepts_nested_attributes_for :notes,:reject_if => lambda { |a| a[:message].blank? }, :allow_destroy => true
  validates_presence_of :performed, :message => I18n.t(".must_enter_performed_date")

  validate :validate_all

  scope :for_vehicle, lambda { |vehicle_id| { :conditions =>  ["vehicle_id = ?", vehicle_id] ,:order => "performed desc"} }

  before_save :before_save_call_back
  after_save :to_after_save
  after_initialize :init

  normalize_attributes :comment

  def my_services
    if deleted?
      services.with_deleted
    else
      services
    end
  end

  def status_name
    status ? status.name : ""
  end

  def before_save_call_back
    set_status
    set_company_client
    generate_new_number
  end

  def generate_new_number
    unless self.nro
      self.nro = CompanyAttribute.generate_workorder_number self.company_id
    end
  end

  def set_company_client
    vehicle = self.vehicle
    unless vehicle.user.service_centers.map(&:id).include?(self.company_id)
      comp = Company.find_by_id(self.company_id)
      vehicle.user.service_centers << comp if comp
      # vehicle.user.companies_users.create(user_id: vehicle.user.id, company_id: comp.id) if comp
      # vehicle.user.service_centers.create(company: comp) if comp
    end
  end

  def to_after_save
    if is_finished?
      regenerate_events
      send_notification if vehicle.user.confirmed_at
      update_vehicle_service_offers
    end
  end
  # La orden de trabajo esta terminada si el estado de todos sus servicios
  # tienen el final status
  def is_finished?
    return false unless status_id
    final_status = company ? company.get_final_status : Company.default_final_status
    services.where("status_id = ?",final_status.id).count == services.count
  end

  def is_open_for_autopart?
    false
  end

  def update_vehicle_service_offers
    VehicleServiceOffer.update_with_services(self.services)
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
  def initialize_with_vehicle_service_offer companies_ids
    if vehicle
      vehicle_services_offers =  vehicle.search_service_offer(companies_ids)

      vehicle_services_offers.each do |vehicle_service_offer|
        vehicle_service_offer.service_offer.service_types.each do |st|

          prev_service = self.services.find{|s| s.service_type_id == st.id}

          if prev_service
            prev_service.today_vehicle_service_offer << vehicle_service_offer
          else
            new_service = Service.new(service_type_id: st.id,vehicle_service_offer_id: vehicle_service_offer.id)
            new_service.vehicle_service_offer = vehicle_service_offer
            new_service.today_vehicle_service_offer << vehicle_service_offer
            new_service.material_services << MaterialService.new(amount: 1,price: 0)
            self.services << new_service
          end
        end
      end
    end
  end

  # inizializo una orden de trabajo con un budget
  def initialize_with_budget n_budget
    self.vehicle = n_budget.vehicle
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
    unless self.performed
      self.performed = Time.zone.now.to_date
    end
  end

  def validate_all
    if self.services.empty?
      errors[:services] << "La orden de trabajo debe contener servicios"
    end

    unless self.user
      errors[:user] << "no puede ser vacio"
    end

    if self.user && self.user.company
      if self.deliver.nil? and self.vehicle.is_car?
        errors[:deliver] << "no puede ser vacio"
      end
      unless user.company.is_employee?(user)
        errors[:services] << "El prestador de servicios es incorrecto"
      end

    end

  end

  def find_vehicle_service_offer(company_id,status= Status::CONFIRMED)
    vehicle_service_offer = VehicleServiceOffer.vehicles(vehicle.id).company(company_id).by_status(status)
    vehicle_service_offer.each do |cso|
      service = services.select{|s| s.service_type.id == cso.service_offer.service_type.id}.first
      service.vehicle_service_offer = cso if service
    end
    vehicle_service_offer
  end

  def vehicle_service_offers
    services.map{|s| s.vehicle_service_offer}.delete_if{|cso| cso == nil}
  end

  def total_price
    if deleted?
      self.services.with_deleted.inject(0){|sum, service| sum + service.total_price }
    else
      self.services.inject(0){|sum, service| sum + service.total_price }
    end
  end

  def payment_method_name
    payment_method ? payment_method.name : ""
  end

  def detail
    str=""
    services.each do |s|
      str += s.service_type.name
    end
    str
  end

  def generate_events
    if (self.vehicle.kmAverageMonthly && (self.vehicle.kmAverageMonthly > 0))
      services.each do |service|
        unless service.cancelled
          if service.service_type.is_periodic?
            new_event = create_event(service)
            #busco evento a futuro para el mismo tipo de servicio, me quedo con el ultimo realizado
            service_future = Service.find_future(service).last
            if service_future
              # si hay , cancelo el evento con el servicio a futuro realizado
              new_event.status =Status::CANCELLED
              new_event.service_done = service_future
            else
              # si no hay servicios del mismo tipo en el futuro
              # busco los eventos y actualizo su estado a CANCELLED por este nuevo servicio
              # actualizo el estado de eventos futuros o pasados
              Workorder.update_event_status service
            end
            #grabo el evento en la base de datos
            new_event.save
          end
        end
      end
    end
  end

  def regenerate_events

    Event.transaction do
      services.each{|service| service.events.clear}
      generate_events
    end

  end

  def set_status
    final_status = company ? company.get_final_status : Company.default_final_status
    service_status_id = self.services.map(&:status_id).uniq
    self.status_id = service_status_id.size == 1 ? service_status_id.first : nil
  end

  def belong_to_user user
    user.vehicles.include?(vehicle)
  end

  def can_show_pdf? user
    vehicle.user == user
  end

  def can_print_pdf? user
    can_show?(user) && user.is_employee?
  end

  def can_send_message?(usr)
    vehicle.user.id != usr.id
  end

  def can_rank? user
    vehicle.user == user || (company && company.is_employee?(user))
  end

  def can_delete?(usr)
    return false if self.deleted?

    if ((user.id == usr.id) && usr.is_vehicle_owner?)
      return true
    end

    can_edit?(usr)
  end

  def can_edit?(usr)
    return false if self.deleted?

    if ((user.id == usr.id) && user.own_this_vehicle?(self.vehicle))
      return true
    end

    #return true if status_id == id
    if usr.is_administrator? || (!usr.is_administrator? && !is_finished?)
      if company.is_employee?(usr)
        return true
      end
    end
    return false
  end

  def can_show?(usr)
    # si el usuario de la orden de trabajo es el dueno del auto
    return true if usr.own_vehicle(vehicle)

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

    return nil unless service_type.is_periodic?

    newDueDate = nil
    if (service_type.kms && service_type.kms > 0)
      months = (service_type.kms / vehicle.kmAverageMonthly.to_f).round.to_i
      newDueDate = (service.workorder.performed + months.month)
    elsif (service_type.days && service_type.days > 0)
      newDueDate = service_type.days.days.since
    end

    if newDueDate
      new_kms = service_type.kms ? (self.vehicle.km + service_type.kms) : 0
      event = service.events.build(vehicle: self.vehicle,km: new_kms,
        service_type: service_type,status: (Status::ACTIVE),dueDate: newDueDate)
    end

    event
  end

  def send_notification
    logger.info "### envio de notificacion mail #{self.id} Vehicle: #{self.vehicle.domain}"
    Resque.enqueue WorkorderJob,self.id
  end


  def delete_event service
    logger.debug "### #{service.id} #{service.workorder}"
    events = Event.green.vehicle(service.workorder.vehicle.id).service_typed(service.service_type.id)
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


  def self.to_csv(filePath, company_id)
    filters_params = {}
    filters_params[:company_id] = company_id
    wos = find_by_params(filters_params).limit(30)

    CSV.open(filePath, "w+",{:col_sep => ","}) do |csv| #, :force_quotes => true
      csv << csv_column_names

      wos.each do |wo|

        wo_values = csv_workorder_row_values(wo)

        wo.services.each do |service|
          wo_service_values = wo_values.clone + [service.service_type.name]

          service.material_services.each do |mat_service|
            row = wo_service_values.clone + [mat_service.material_detail, mat_service.amount, mat_service.price]
            csv << row
          end

        end
      end

    end
  end

  def self.csv_column_names
    ["id","company","vehicle","vehicle_kms","customer","performed","comment","status","payment_method","budget_id","deliver","created_at","updated_at","service","material","material_amount","material_price"]
  end

  def self.csv_workorder_row_values(wo)
#               ["id" ,"company"       ,"car"         ,"car_km","user"          ,"performed"  ,"comment"  ,"status"                  ,"payment_method"       ,"budget_id"  ,"deliver"  ,"created_at"  ,"updated_at"]
    wo_values = [wo.id, wo.company.name, wo.car.domain, wo.km, wo.user.full_name, wo.performed, wo.comment, wo.status.name, wo.payment_method_name, wo.budget_id, wo.deliver, wo.created_at, wo.updated_at]
  end

  def self.workorder_report_to_csv(params)
    wsList = find_by_params(params)

    #La lista wsList contiene los workorders solo con los services seleccionados en el filtro de la UI
    #Por ejemplo si un workorder tiene los services "Alineacion y Balancio" y "Cambio de Neumatico"
    #y se ha filtrado en la UI por "Cambio de Neumatico" esa workorder en la lista wsList contiene solo el servicio
    # "Cambio de neumatico" por ello para tener la orden completa antes de escribir el csv voy a traer
    #cada workorder de la base de datos

    CSV.generate do |csv|
      csv << [I18n.t('workorder'), I18n.t('vehicle'), I18n.t('client'), I18n.t('salesman'), I18n.t('workorder_date'), I18n.t('total_price'), I18n.t('service_id'), I18n.t('service'), I18n.t('service_price'), I18n.t('material_amount'), I18n.t('material_price'), I18n.t('material_total_price'), I18n.t('material_code'), I18n.t('material_prov_code'), I18n.t('material'), I18n.t('employee')]

      if wsList.present?
        wsList.each do |wo|

          wo = Workorder.find(wo.id) #para obtener la orden completa

          wo_full_data = true
          row_ws = [wo.id, nil, nil, nil, nil, nil]
          row_ws_full_data = [wo.id, wo.vehicle.domain, wo.vehicle.user.full_name, wo.user.full_name, I18n.l(wo.performed), wo.total_price]

          wo.services.each do |service|
            s_full_data = true
            row_s = [service.service_type.id, service.service_type.name, nil]
            row_s_full_data = [service.service_type.id, service.service_type.name, service.total_price]

            service.operator.present? ? row_s_empl = [service.operator.full_name] : row_s_empl = [nil]

            service.material_services.each do |mat_service|

              if wo_full_data
                row = row_ws_full_data
                wo_full_data = false
              else
                row = row_ws
              end

              row_m = [mat_service.amount, mat_service.price, mat_service.total_price, mat_service.material_code, mat_service.material_prov_code, mat_service.material_name]

              if s_full_data
                csv << row + row_s_full_data + row_m + row_s_empl
                s_full_data = false
              else
                csv << row + row_s + row_m
              end

            end
          end
        end
      end
    end
  end

  def confirm_price_offer(price_offer_id)
    self.price_offers.update_all(confirmed: false)
    price_offer = PriceOffer.find price_offer_id
    price_offer.update_attributes(confirmed: true) if price_offer.present?
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

    workorders = Workorder.order(filters[:order_by]).includes(:payment_method,:company,:vehicle =>:user,:services => [{:material_services => [{:material_service_type =>[:service_type, :material]}]}])

    workorders = workorders.only_deleted if filters[:deleted]

    workorders = workorders.where("users.first_name like ?","%#{filters[:first_name]}%") if filters[:first_name]
    workorders = workorders.where("users.last_name like ?","%#{filters[:last_name]}%") if filters[:last_name]
    workorders = workorders.where("users.company_name like ?","%#{filters[:company_name]}%") if filters[:company_name]

    workorders = workorders.where("vehicles.id = ?","#{filters[:vehicle_id]}") if filters[:vehicle_id]

    workorders = workorders.where("vehicles.domain like ?","%#{filters[:domain].upcase}%") if filters[:domain]
    workorders = workorders.where("vehicles.chassis like ?","%#{filters[:chassis].upcase}%") if filters[:chassis]

    workorders = workorders.where("workorders.vehicle_id IN (?)", filters[:user].vehicles.map(&:id)) if filters[:user] && filters[:user].is_vehicle_owner?

    workorders = workorders.where("performed between ? and ? ",filters[:date_from].to_datetime.in_time_zone,filters[:date_to].to_datetime.in_time_zone) if (filters[:date_from] && filters[:date_to])

    workorders = workorders.where("performed <= ? ",filters[:date_to].to_datetime.in_time_zone) if ((filters[:date_from] == nil) && filters[:date_to])
    workorders = workorders.where("performed >= ? ",filters[:date_from].to_datetime.in_time_zone) if (filters[:date_from] && (filters[:date_to] == nil))

    workorders = workorders.where("workorders.company_id IN (?)",filters[:company_id]) if filters[:company_id]

    workorders = workorders.where("lower(materials.name) like ? or lower(material_services.material) like ?" ,"%#{filters[:material].downcase}%", "%#{filters[:material].downcase}%") if filters[:material]

    workorders = workorders.where("workorders.nro = ?", filters[:number]) if filters[:number]
    workorders = workorders.where("workorders.status_id = ? or workorders.status_id is null", filters[:wo_status_id]) if filters[:wo_status_id]
   
    workorders = workorders.where("services.service_type_id IN (?) AND services.deleted_at IS NULL",filters[:service_type_ids]) if filters[:service_type_ids]
    
    workorders
  end

  def self.update_event_status service
    unless service.cancelled
      #busco los servicios rojos y amarillos
      events =  Event.vehicle(service.workorder.vehicle.id).service_typed(service.service_type.id).active.map(&:id)
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

  def can_view_comments?(user)
    companies = user.companies
    if companies.any?
      companies.include?(company)
    else
      false
    end
  end

  def new_save
    result = false
    begin
      result = self.save
    rescue ActiveRecord::RecordNotUnique => e
      self.errors[:base] << "Número de Orden de Trabajo Duplicado, por favor actualize la Configuracón de la Compañia"
      result = false
    end
    result
  end

  def self.service_types_for user,companies_ids
    st = ServiceType.joins(:services => :workorder)
    st = st.where("workorders.company_id IN (?)",companies_ids)if companies_ids
    st = st.where("workorders.user_id = ?",user.id) unless companies_ids
    st = st.group("service_types.id")
    st
  end

  def self.get_last_number company_id
    o = Workorder.order("nro DESC").where("company_id = ?",company_id).first
    return (o ? o.nro : 0)
  end

  def control_material?
    if company
      company.control_material?
    else
      false
    end
  end
end
