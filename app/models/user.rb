class User < ActiveRecord::Base

  @@lock = Mutex.new
  @@last_number = 0

  # Include default devise modules. Others available are:
	# :http_authenticatable, :token_authenticatable, :confirmable,:lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable,:rememberable, :trackable, :validatable
  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation

  # Get Imge from GRAvatar
  # is_gravtastic(:size=> 50,:default =>"mm")

  attr_accessible :first_name, :last_name, :phone, :email, :cuit, :company_name, :cars_attributes, :address_attributes, :password, :password_confirmation, :companies_attributes,:employer_id, :role_ids

  attr :type, true

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
  has_one :company_active,:class_name=>"Company",:conditions=>"active=1"
  belongs_to :employer,:class_name =>"Company",:foreign_key=>'employer_id'

  has_many :alarms, :dependent => :destroy
  has_many :messages

  validates_uniqueness_of :email, :case_sensitive => false

  accepts_nested_attributes_for :address,:reject_if =>lambda {|a| a[:street].blank?}
  accepts_nested_attributes_for :companies,:reject_if =>lambda {|a| a[:name].blank?}
  accepts_nested_attributes_for :cars,:reject_if =>lambda {|a| a[:domain].blank?}

  scope :clients ,lambda{joins("left outer join companies on companies.user_id = users.id").where("companies.user_id is NULL")}

  NULL_ATTRS = %w( company_name cuit )
  before_save :nil_if_blank
  #validate :validate_all

  def validate_all
    unless self.creator.companies.find_by_id(self.employer_id)
      errors.add_to_base("El empleador es incorrecto")
    end
  end

  def self.company_clients companies_ids  
    User.joins(:companies_users).where("companies_users.company_id in (?)", companies_ids).order("users.last_name")  
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
    
    unless ids
      offers = ServiceOffer.cars(cars.map(&:id)).sended        
    else
      offers = ServiceOffer.where("company_id IN (?)",ids)
    end
  
    if filters
      offers = offers.where("service_type_id = ?",filters[:service_type_id]) unless filters[:service_type_id].empty?
      offers = offers.where("since >= ?",filters[:form].to_datetime.in_time_zone) unless filters[:form].empty?
      offers = offers.where("until <= ?",filters[:until].to_datetime.in_time_zone) unless filters[:until].empty?
      offers = offers.where("title like ?","%#{filters[:title]}%") unless filters[:title].empty?
      offers = offers.where("status in (?)",filters[:status]) if filters[:status]
    end
    offers.order("service_offers.created_at DESC")
  end

  def service_types
    if company
      return company.service_type
    else
      return ServiceType.all
    end
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
    
  end

  def own_car car
    cars.select{|c| c.id == car.id}.size > 0
  end

  def employees
    User.where("employer_id = ? ",id)
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

  def is_employee?(usr=nil)
    return employer != nil unless usr
    (companies && companies.includes(:companies_users).where("companies_users.user_id = ?",id).size >= 0) ? true : false
  end

  def is_car_owner?
    car_owner = true
    if has_company? || is_employee?
      car_owner = false
    end
    car_owner
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

  def service_types
    if company
      sp = company.service_type
    else
       sp = ServiceType.all(:order =>"name")
    end
   sp
  end

  def state
    return address.state if address && address.state
  end

  def can_edit? user
    (self.id == user.id) || (user.confirmed_at.nil? && is_client?(user))
  end

  def can_edit_car? car
    self == car.user && is_client?(car.user)
  end

  def is_client? user    
    Company.is_client?(get_companies_ids,user.id)
  end

  def unread_messages_nro
    Message.where("receiver_id = ?",self.id).unread.count
  end

  def next_alarm_nro
    alarms.active.run_in_next_hours(24).count
  end

  def service_type_templates(id)
    templates = company.service_type_templates
    templates = templates.where("service_type_id = ?",id) if id
    templates
  end

  def self.last_number
    @@last_number
  end

  def self.get_last_email
    User.where("email like ?","test%@comunidadbox.com").order("email DESC").pluck("email").first
  end


  def self.get_last_number
    nro = 0
    email = get_last_email
    nro = email.scan(/\d+/).first.to_i if email
  
    @@last_number =   @@last_number < nro ? nro + 1 : @@last_number + 1

    @@last_number
    
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

  

end

