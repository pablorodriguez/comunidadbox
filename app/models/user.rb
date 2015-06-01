# encoding: utf-8
class User < ActiveRecord::Base
  extend Enumerize

  TYPES = {
    "fu"=> "Usuario","ps"=>"Prestador de Servicios","au" => "Autopartista"
    }

  @@lock = Mutex.new
  @@last_number = 0

  # Include default devise modules. Others available are:
	# :http_authenticatable, :token_authenticatable, :confirmable,:lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable,:rememberable, :trackable, :validatable, :confirmable
  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation

  # Get Imge from GRAvatar
  # is_gravtastic(:size=> 50,:default =>"mm")

  attr_accessible :first_name, :last_name, :phone, :email, :cuit, :company_name, :vehicles_attributes,
                  :address_attributes, :password, :password_confirmation, :companies_attributes,
                  :employer_id, :role_ids, :user_type, :vehicles_attributes,:external_id,:close_system,:created_at,
                  :confirmed,:creator_id,:confirmed_at
  
  attr :type, true

  enumerize :user_type, in: {:vehicle_owner => 1, :service_center => 2, :auto_part => 3}, predicates: true

  has_many :service_filters,:order =>'name'

  has_many :vehicles
  # has_many :cars
  # has_many :motorcycles
  # delegate :cars, :motorcycles, to: :vehicles


  has_many :authentications
  has_many :notes,:order => "created_at DESC"

  belongs_to :creator,:class_name=>'User'
  has_many :companies, :order => 'name ASC'
  has_many :companies_users
  has_many :service_centers, :through => :companies_users, :source => :company

  belongs_to :supplier, :class_name => 'Company', :foreign_key => 'supplier_id'
  has_many :user_roles
  has_many :roles, :through => :user_roles

  has_one :address,:dependent => :destroy
  #has_one :company_active,:class_name=>"Company",:conditions=>"active=1"
  belongs_to :employer,:class_name =>"Company",:foreign_key=>'employer_id'

  has_many :alarms, :dependent => :destroy
  has_many :messages
  has_many :material_requests

  has_one :export
  has_many :price_offers

  validates_uniqueness_of :email, :case_sensitive => false
  #validates_presence_of :first_name, :last_name
  #validates_presence_of :vehicles, :on => :create


  accepts_nested_attributes_for :address, :reject_if => :all_blank
  accepts_nested_attributes_for :companies, :reject_if =>lambda { |a| a[:name].blank? }
  accepts_nested_attributes_for :vehicles, :reject_if => :all_blank, :allow_destroy => true
  # accepts_nested_attributes_for :cars, :reject_if => :all_blank
  # accepts_nested_attributes_for :motorcycles, :reject_if => :all_blank

  #scope :motorcycles,where("vehicle_type = 'Motorcyle'")
  #after_initialize :set_default_data
  validate :custom_validations
  after_save :set_client_data
  before_validation :set_default_data

  def set_client_data
    if creator_id
      company = User.find(creator_id).company
      unless company.is_client?(self)
        compUser = CompaniesUser.new({user_id: self.id,company_id: company.id})
        compUser.save
      end
    end
  end

  def custom_validations
    if (first_name.nil? || first_name.empty?) && (last_name.nil? || last_name.empty?) && company_name.empty?
      errors[:domain] << "El Dominio no puede estar vacio"
    end
  end

  def cars
    self.vehicles.select{|v| v.vehicle_type == "Car"}
  end
  
  def motorcycles
    self.vehicles.select{|v| v.vehicle_type == "Motorcycle"}
  end

  scope :enabled , where("disable is NULL")
  scope :clients ,lambda{joins("left outer join companies on companies.user_id = users.id").where("companies.user_id is NULL")}

  NULL_ATTRS = %w( company_name cuit )
  #validate :validate_all
  # alias :cars :vehicles

  def valid_eamil
    email.end_with?("@comunidadbox.com") ? "" : email
  end

  def company_active
    return employer if employer
    return companies.where("active=1").first
  end

  def set_default_data
    if self.new_record?
      unless self.password
        self.password = "test12345"
        self.password_confirmation = self.password
      end
      if self.email.try(:empty?)
        self.email = User.generate_email
        skip_confirmation!
      end
    end
  end

  def search_material_request(status,detail)
    if self.is_super_admin?
      m = MaterialRequest.where("description like ?","%#{detail}%")
    else
      m = self.material_requests.where("description like ?","%#{detail}%")
    end

    unless status.empty?
      m = m.where("status =?",status)
    end
    m
  end

  def validate_all
    unless self.creator.companies.find_by_id(self.employer_id)
      errors[:base] << "El empleador es incorrecto"
    end
  end

  def self.company_clients companies_ids
    User.includes(:companies_users).where("companies_users.company_id in (?)", companies_ids)
  end

  def nil_if_blank
    NULL_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? }
  end

  def belongs_to_company comp
    unless (self.companies.empty?)
        return self.companies.select{|c| c.id == comp.id}.size > 0
    end
    return (self.company && self.company.id == comp.id)
  end

  def find_service_offers(filters,ids)
    if is_super_admin?
      offers = ServiceOffer.confirmed
    elsif ids
      offers = ServiceOffer.where("company_id IN (?)",ids)
    else
      offers = ServiceOffer.vehicles(vehicles.map(&:id)).sended
    end

    if filters
      offers = offers.where("service_type_id = ?",filters[:service_type_id]) unless filters[:service_type_id].empty?
      offers = offers.where("since >= ?",filters[:form].to_datetime.in_time_zone) unless filters[:form].empty?
      offers = offers.where("until <= ?",filters[:until].to_datetime.in_time_zone) unless filters[:until].empty?
      offers = offers.where("title like ?","%#{filters[:title]}%") unless filters[:title].empty?
      offers = offers.where("status in (?)",filters[:status]) if filters[:status]
    end

    offers
  end

  def service_types_active
    return Company.default_service_types unless company
    headquarter.service_types.active
  end

  def service_types
    return Company.default_service_types unless company
    return company.service_types.active unless company.service_types.empty?
    return company.user.headquarter.service_types.active
  end

  def all_notes
    Note.where("user_id = :user_id or creator_id = :user_id", user_id: self.id).order("created_at desc")
  end

  def service_offers(status=nil)
    services = []
    vehicles.each do |c|
      so = ServiceOffer.where("vehicle_service_offers.vehicle_id = ?",c.id).includes(:vehicle_service_offer)
      if status
        so = so.where("service_offers.status = ?","Enviado")
      end
      services << so
    end
    services.flatten
  end

  def own(comp)
    return true if company_id == comp.id
    return companies.select{|c| c.id == comp.id}.size > 0 ? true : false
  end

  def vehicles_ids
    self.vehicles.map(&:id)
  end

  def own_vehicle vehicle
    vehicles.select{|c| c.id == vehicle.id}.size > 0
  end

  def employees(company_id = nil)
    unless company_id
      comp_ids = get_companies_ids
    else
      comp_ids =[company_id]
    end

    return User.enabled.where("employer_id IN (?) ",comp_ids)
  end

  def company_active_employees
    employees(company_active.id)
  end

  def company
    return company_active unless companies.empty?
    return employer if employer
  end

  def after_initialize2
    self.build_address if self.address.nil?
    self.vehicles.build if self.vehicles.empty?
    #- @user.user_addresses[0].address = Address.new
  end

  def has_company?
    companies.size > 0
  end

  def company_id
    if company
      return company.id
    elsif employer
      return employer.id
    end
  end

  def current_address
    if self.address
      return self.address
    elsif self.company
      return self.company.address
    elsif self.employer
      return self.employer.address
    end
  end

  def address_text
    current_address ? current_address.to_text : ""
  end

  def get_companies
    return creator.companies if is_manager?
    return companies unless companies.empty?
    return employer.user.companies if is_employee?
    return []
  end

  def get_companies_ids
    comp = get_companies
    unless comp.empty?
      comp = comp.map(&:id)
    end
    comp
  end

  def headquarter
    if companies.empty?
      return employer.user.headquarter if employer
    else
       comp = companies.select{|c| c.headquarter}.first
       return comp ? comp : company_active
    end

  end


  def get_company_id_for_materials
    get_company_id(:materials)
  end

  def get_company_id_for_service_types
    get_company_id(:service_types)
  end

  # Return company id to be use in Materials, Service Types
  # Context can me materials or service types
  def get_company_id(context)
    id = nil
    if context == :materials
      if Material.has_for_company?(company_id)
        id = company_id
      else
        id = company.user.headquarter.id
      end
    elsif context == :service_types
      if ServiceType.has_for_company?(company_id)
        id = company_id
      else
        id = company.user.headquarter.id
      end
    end

    id
  end

  def get_companies_ids
    get_companies.map(&:id)
  end

  def future_events(args={})
    per_page = args[:per_page]
    vehicle_id = args[:vehicle_id]
    service_type_id = args[:service_type_id]

    vehicles_ids = vehicles.each{|c|c.id.to_i} unless vehicle_id
    vehicles_ids = [vehicle_id] if vehicle_id
    events = Event.where("dueDate >= ? and vehicle_id in(?)",Time.zone.now,vehicles_ids)

    events = events.includes(:service_type).where("service_types.id = ?",service_type_id) if service_type_id
    events = events.paginate(:page => 1,:per_page=>per_page) if per_page

    events
  end

  def is_manager?
    find_role Role::MANAGER
  end

  def is_administrator?
    find_role Role::ADMINISTRATOR
  end

  def is_super_admin?
    find_role Role::SUPER_ADMIN
  end

  def is_employee?
    if employer == nil && company_active == nil
      return false
    end

    if employer
      return true
    end
    company_active != nil
  end

  def is_vehicle_owner?
    !is_employee?
  end

  def find_role(role_name)
    roles.select{|r| r.name == role_name}.first != nil
  end

  def full_name
    (first_name.blank? && last_name.blank?) ? company_name : "#{first_name} #{last_name}"
  end

  def price_list
    if company
      PriceList.find_by_company_id_and_active company.id,1
    end
  end

  def self.email_confirmation(user)
    begin
      result = MiddleMan.worker(:mailer_worker).async_user_activation_notification(:arg => user.id)
      logger.debug "Mailer sent #{result}"
    rescue Exception => e
      logger.debug "Error #{e} (#{e.class})!"
    end
  end

  def state
    return address.state if address && address.state
  end

  def can_edit? user
    (self.id == user.id) || (user.confirmed_at.nil? && is_client?(user))
  end

  def can_read? user
    can_read = false
    can_read = true if self == user 
    can_read = true if !can_read && user.is_client?(user) 
    if !can_read && self.company
      if self.close_system
        can_read = false
      else
        can_read = true 
      end
    else
      can_read = false
    end
    can_read
  end

  def only_client user

  end

  def can_edit_vehicle? vehicle
    self == vehicle.user && is_client?(vehicle.user)
  end

  def is_client?(user)
    Company.is_client?(get_companies_ids,user.id)
  end

  def unread_messages_nro(user=nil)
    if user
      Message.where("user_id = ? AND receiver_id = ?",user.id,self.id).unread.count
    else
      Message.where("receiver_id = ?",self.id).unread.count
    end
  end

  def next_alarm_nro
    alarms.active.run_in_next_hours(24).count
  end

  def service_type_templates(id)
    if company
      templates = company.service_type_templates
      templates = templates.where("service_type_id = ?",id) if id
      templates
    else
      []
    end
  end

  def self.last_number
    @@last_number
  end

  def self.get_last_email
    User.where("email like ?","test%@comunidadbox.com").order("id DESC").pluck("email").first
  end


  def self.get_last_number
    nro = 0
    email = get_last_email
    nro = email.scan(/\d+/).first.to_i if email

    last_number =   @@last_number < nro ? nro + 1 : @@last_number + 1

    last_number

  end

  def self.generate_email_schync
    "test#{get_last_number}@comunidadbox.com"
  end


  def self.generate_email
    mail = ""
    @@lock.synchronize do
      mail = User.generate_email_schync
    end
    mail
  end

# 0  ["Id externo","123456"],
# 1  ["Nombre","Jaime"],
# 2  ["Apellido","Gil"],
# 3  ["Teléfono","2616585858"],
# 4  ["Email","jaimito@jaime.com"],
# 5  ["CUIT",null],
# 6  ["Razón Social",null],
# 7  ["Provincia","Mendoza"],
# 8  ["Ciudad","Mendoza"],
# 9  ["Calle","Beltran 158"],
# 10 ["Código Postal","5500"],
# 11 ["Dominio","UGB376"],
# 12 ["Marca","Fiat"],
# 13 ["Modelo","Palio"],
# 14 ["Combusitble","Diesel"],
# 15 ["Año","2000"],
# 16 ["kilometraje promedio mensual","2000"],
# 17 ["kilometraje","252025"]
# 18 ["Tipo de Servicio","Mantenimiento General"]
# 19 ["Fecha","12/12/2015"]

  def self.import_clients(file, current_user,company_id,encode)
    company = Company.find company_id
    csv_text = File.read(file.open,:encoding => encode)
    csv = CSV.parse(csv_text, :headers => true)
    result = {
      :summary => [],
      :errors => [],
      :failure => 0,
      :success => 0,
      :new_records =>0,
      :updates =>0
    }

    i = 1
    success = 0
    failure = 0

    csv.each do |row|
      begin
        i+=1
        params = create_client_params(row,current_user,company)
        client = User.find_by_external_id(params[:user][:external_id]) if params[:user][:external_id] 
        client = User.new(params[:user]) unless client
        #if theres is event to add
        service_type = nil
        if params[:service_type_name]
          service_type = company.service_types.where("name = ?",params[:service_type_name]).first
          unless service_type
            client.errors[:base] << "#{service_type_name} no es un Tipo de Servicio valido"
          end
        end

        unless client.id
          client.skip_confirmation!
          save_ok = client.save
          save_ok = client.update_attributes({confirmed_at: nil}) if save_ok
          result[:new_records] += 1
        else
          save_ok = client.update_attributes(params[:user])
          result[:updates] += 1
        end

        if save_ok
          result[:success] += 1
        else
          result[:errors] << [i,client]
        end

        if service_type
          vehicle = client.vehicles.first
          vehicle.events.create({:service_type_id => service_type.id,:dueDate => params[:event_due_date],:status =>Status::ACTIVE})
        end

      rescue Exception => e  
        logger.error e.message
        result[:fatal] = "Hay un error en la importación de ventas, por favor contacte al Administrador del sitio. Muchas gracias"
      end

    end

    result[:failure] = result[:errors].size
    result[:total_records] = (result[:success] + result[:failure])
    result
  end


  def self.create_client_params row,current_user,company
    external_id = row[0].strip
    created_at = row[1]
    first_name = row[2]
    last_name = row[3]
    phone = row[4]
    email = row[5]
    cuit = row[6]
    company_name = row[7]
    state_name = row[8]
    city = row[9]
    street = row[10]
    zip = row[11]
    domain = row[12]
    brand_name = row[13]
    model_name = row[14]
    chassis = row[15]
    fuel = row[16]
    year = row[17]
    kmAverageMonthly = row[18] || 0
    km = row[19] || 0
    service_type_name = row[20]
    event_due_date = row[21]

    brand = Brand.find_by_name(brand_name)

    if model_name && brand.nil?
      model = Model.includes("brand").where("models.name like ? and brands.company_id = ?",model_name,company.id).first
    else
      model = Model.includes("brand").where("brands.name =? and models.name =? and company_id = ?",brand_name,model_name,company.id).first
    end

    model_id = model ? model.id : ""
    if brand.nil? and !model.nil?
      brand = model.brand
    end
    brand_id = brand ? brand.id : ""

    vehicle_type = (model && model.brand.of_cars) ? "Car" : "Motorcycle"
    state = State.find_by_name(state_name)
    state_id = state ? state.id : nil

    params = {
      event_due_date: event_due_date,
      service_type_name: service_type_name,
      user:{
        first_name: first_name,
        last_name: last_name,
        cuit: cuit,
        phone: phone,
        company_name: company_name,
        email: email,
        external_id: external_id,
        creator_id: current_user.id,
        created_at: created_at,
        address_attributes: {
          state_id: state_id,
          city: city,
          street: street,
          zip: zip
        },
        vehicles_attributes:[{
          domain: domain,
          chassis: chassis,
          km: km,
          kmAverageMonthly: kmAverageMonthly,
          brand_id: brand_id,
          year: year,
          model_id: model_id,
          fuel: fuel,
          vehicle_type: vehicle_type
        }]
      }
    }
    params
  end

  def self.add_error_if_not_valid model,result
    unless model.valid?
        result[:errors] << model
        result[:failure] += 1
    end
  end

end
