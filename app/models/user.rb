class User < ActiveRecord::Base
  
  # Include default devise modules. Others available are:
	# :http_authenticatable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable,:rememberable, :trackable, :validatable
  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation

  # Get Imge from GRAvatar
  # is_gravtastic(:size=> 50,:default =>"mm")
  
  attr :type, true
  
  has_many :service_filters,:order =>'name'
  has_many :cars
  has_many :authentications
  
  belongs_to :creator,:class_name=>'User'
  has_many :companies
  
  belongs_to :supplier, :class_name => 'Company', :foreign_key => 'supplier_id'
  has_many :user_roles
  has_many :roles ,:through => :user_roles
  
  has_one :address
  has_one :company_active,:class_name=>"Company",:conditions=>"active=1"
  belongs_to :employer,:class_name =>"Company",:foreign_key=>'employer_id'
  
  has_many :alarms, :dependent => :destroy

  #validates_presence_of :email
  validates_uniqueness_of :email, :case_sensitive => false

  accepts_nested_attributes_for :address,:reject_if =>lambda {|a| a[:street].blank?}
  accepts_nested_attributes_for :companies,:reject_if =>lambda {|a| a[:name].blank?}
  accepts_nested_attributes_for :cars,:reject_if =>lambda {|a| a[:domain].blank?}
  
  #validate :validate_addresses
  def current_company
    return company if company
    return employer if employer
  end
  
  def find_service_offers(filters = nil)
    
    if self.is_super_admin
      offers = ServiceOffer.confirmed
    elsif self.is_administrator
      offers = company.service_offers
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
  
  def service_types
    if company
      return company.service_type
    else
      return ServiceType.all
    end
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
    if company_id == comp.id
      return true
    end
    companies.each do |c|
      if c.id == comp.id
        puts "aca each #{c.id} #{company.id}"
        return true
      end
    end
    return false
  end
  
  def own_car car
    cars.select{|c| c.id = car.id}.size > 0
  end
  
  def employees
    User.where("employer_id = ? ",id)
  end
  
  def company
    return company_active if companies.size > 0 
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
  
  
  def future_events(args={})
    per_page = args[:per_page]
    car_id = args[:car_id]
    service_type_id = args[:service_type_id]
    
    cars_ids = cars.each{|c|c.id.to_i} unless car_id
    cars_ids = [car_id] if car_id
    events = Event.where("dueDate >= ? and car_id in(?)",Time.now,cars_ids)
    
    events = events.includes(:service_type).where("service_types.id = ?",service_type_id) if service_type_id
    events = events.paginate(:page => 1,:per_page=>per_page) if per_page
    
    events
  end

  def is_administrator
    find_role Role::ADMINISTRATOR
  end

  def is_super_admin
    find_role Role::SUPER_ADMIN
  end
  
  def is_employee
    employer != nil 
  end
  
  def is_car_owner
    car_owner = true
    if has_company? || is_employee
      car_owner = false
    end
    car_owner
  end

  def find_role(role_name)
    roles.select{|r| r.name == role_name}[0] != nil
  end

  def full_name
    (first_name.blank? && last_name.blank?) ? email : "#{first_name.capitalize} #{last_name.capitalize}"  
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
    if current_company
      sp = current_company.service_type
    else
       sp = ServiceType.all(:order =>"name") unless current_company
    end
   sp
  end
 
end

