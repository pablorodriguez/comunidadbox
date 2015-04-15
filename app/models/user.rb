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

  attr_accessible :first_name, :last_name, :phone, :email, :cuit, :company_name, :cars_attributes, :address_attributes, :password, :password_confirmation, :companies_attributes,:employer_id, :role_ids, :user_type

  attr :type, true

  enumerize :user_type, in: {:car_owner => 1, :service_center => 2, :auto_part => 3}, predicates: true

  has_many :service_filters,:order =>'name'
  has_many :cars


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
  validates_presence_of :first_name, :last_name
  #validates_presence_of :cars, :on => :create
  
  
  accepts_nested_attributes_for :address,:reject_if => :all_blank
  accepts_nested_attributes_for :companies,:reject_if =>lambda {|a| a[:name].blank?}
  accepts_nested_attributes_for :cars,:reject_if => :all_blank

  scope :enabled , where("disable is NULL")
  scope :clients ,lambda{joins("left outer join companies on companies.user_id = users.id").where("companies.user_id is NULL")}

  NULL_ATTRS = %w( company_name cuit )
  before_save :set_default_data
  #validate :validate_all

  def company_active
    return employer if employer
    return companies.where("active=1").first
  end

  def set_default_data
    if self.new_record?
      unless self.password
        self.password = first_name + "test" unless first_name.nil?
        self.password = "test" if first_name.nil?
        self.password_confirmation = password
      end
      self.email = User.generate_email unless email
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
      offers = ServiceOffer.cars(cars.map(&:id)).sended
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
    return company.service_types unless company.service_types.empty?
    return company.user.headquarter.service_types
  end

  def all_notes
    Note.where("user_id = :user_id or creator_id = :user_id", user_id: self.id).order("created_at desc")
  end

  def service_offers(status=nil)
    services = []
    cars.each do |c|
      so = ServiceOffer.where("car_service_offers.car_id = ?",c.id).includes(:car_service_offer)
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

  def cars_ids
    self.cars.map(&:id)
  end

  def own_car car
    cars.select{|c| c.id == car.id}.size > 0
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
    self.cars.build if self.cars.empty?
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
    car_id = args[:car_id]
    service_type_id = args[:service_type_id]

    cars_ids = cars.each{|c|c.id.to_i} unless car_id
    cars_ids = [car_id] if car_id
    events = Event.where("dueDate >= ? and car_id in(?)",Time.zone.now,cars_ids)

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

  def is_car_owner?
    !is_employee?
  end

  def find_role(role_name)
    roles.select{|r| r.name == role_name}.first != nil
  end

  def full_name
    (first_name.blank? && last_name.blank?) ? email : "#{first_name} #{last_name}"
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

  def only_client user
    
  end

  def can_edit_car? car
    self == car.user && is_client?(car.user)
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
  
  def self.import_clients(file, current_user,company_id)
    company = Company.find company_id
    csv_text = File.read(file.open,:encoding => 'iso-8859-1')
    csv = CSV.parse(csv_text, :headers => true)
    result = {
      :summary => [],
      :errors => [],
      :failure => 0,
      :success => 0
    }


    i = 1
    success = 0
    failure = 0

    csv.each do |row|
      i+=1
      external_id = row[0].strip
      email = row[4]

      client = User.find_by_external_id external_id if external_id
      client = User.new if client.nil?            

      client.assign_attributes({ 
        :first_name => row[1], 
        :last_name => row[2],
        :cuit => row[5],
        :phone => row[3],
        :company_name => row[6],
        :email => email
      })

      #add_error_if_not_valid client,result

      if client.id.nil?
        client.set_default_data
        client.external_id = external_id
        client.confirmed = true

        client.creator = current_user

        if client && company_id
          unless client.service_centers.include?(company_id)
            client.service_centers << company
          end
        end

      end

      #cargo direccion
      client.address = Address.new({
        :state => State.find_by_name(row[7]),
        :city => row[8],
        :street => row[9],
        :zip => row[10]
      })

      #cargo automovil
      domain = row[11]
      
      car = client.cars.where("domain = ?",domain).first
      if car.nil?
        car = Car.new({:domain => domain})
        client.cars << car
      end

      car.assign_attributes({
        :km => row[17], 
        :kmAverageMonthly => row[16],
        :brand => Brand.find_by_name(row[12]), 
        :year => row[15], 
        :model => Model.includes("brand").where("brands.name =? and models.name =?",row[12],row[13]).first, 
        :fuel => row[14]
      })

      if car.valid?
        car.save 

        #if theres is event to add
        if row[18]
          service_type_name = row[18]
          service_type = ServiceType.find_by_name(service_type_name)
          if service_type
            car.events.create({:service_type_id => service_type.id,:dueDate => row[19],:status =>Status::ACTIVE})
          end
          
        end
      end

      if client.valid? && client.save
        result[:success] += 1
      else
        result[:errors] << client
        result[:failure] += 1
      end

      
    end

    result[:total_records] = (result[:success] + result[:failure])
    result
  end

  def self.add_error_if_not_valid model,result
    unless model.valid?
        result[:errors] << model
        result[:failure] += 1
    end
  end

end

