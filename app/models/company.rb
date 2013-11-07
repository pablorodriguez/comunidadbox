class Company < ActiveRecord::Base
  attr_accessible :user_id, :name, :active, :cuit, :phone, :website, :address_attributes

  validates :name,:presence => true
  validates :address, :presence => true

  has_one :address
  has_one :price_list_active,:class_name=>"PriceList",:conditions=>"active=1"
  belongs_to :user
  has_many :companies_users
  has_many :customers, :through => :companies_users, :source => :user
  has_many :price_lists
  has_many :company_service
  has_many :service_type, :through => :company_service, :order =>'name'
  has_many :workorders
  has_many :employees,:class_name =>'User',:foreign_key =>'employer_id'
  has_many :cars
  has_many :service_offers
  has_many :service_type_templates

  scope :confirmed, includes(:user).where("users.confirmed = 1")

  has_many :material_requests
  DEFAULT_COMPANY_ID = 1

  accepts_nested_attributes_for :address,:reject_if => lambda {|a| a[:street].blank?},:allow_destroy => true
  
  def is_employee usr
    return (user.id == usr.id || ((usr.employer) && (usr.employer.id == id))) ? true : false
  end

  def is_confirmed?
    user.confirmed
  end

  def full_address
    address ? "#{address.street} #{address.city} #{address.state.name}" : ""
  end
  def admin_user
    self.users.select{|u| u.is_company_admin}[0]
  end

  def operators
    User.where("employer_id = ? and roles.name = ? and disable is NULL", self.id,Role::OPERATOR).includes(:roles).order("users.first_name,users.last_name")
  end

  def all_materials
    service_type_materials ={}
    company_service.each do |cst|
      materials = cst.service_type.materials
      service_type_materials[cst.service_type.name]=materials
    end
    service_type_materials
  end

  def user_rank
    rank = Workorder.includes(:ranks).where("ranks.type_rank = 2 and company_id = ?",self.id).sum("cal").to_f
    total_wo = self.workorders.count

    if total_wo == 0
       return 0
    else
      (rank / total_wo)
    end

  end

  def total_work_order
    self.workorders.count
  end

  def total_user_ranked
    Workorder.includes(:ranks).where("ranks.type_rank = 2 and company_id = ?",self.id).count    
  end

  def self.search params
    name =params[:name] || ""
    city = params[:city] || ""
    state_id =params[:company][:state_id]
    street = params[:street]
    companies = Company.where("companies.name like ?","%#{name}%").includes(:address =>[:state]).where("addresses.city like ? and addresses.street like ?","%#{city}%","%#{street}%")
    unless state_id == ""
      companies = companies.where(" states.id = ?",state_id.to_i)
    end
    return companies
  end

  def future_events
    company_cars = Car.where("company_id = ?",id)
    cars_ids = company_cars.each{|c|c.id.to_i}
    Event.all(:conditions=>["dueDate >= ? and car_id in(?)",Time.zone.now,cars_ids])
  end

  def self.best(state_id = nil)
    return Company.confirmed.includes(:address).where("addresses.state_id = ? and companies.id > 1",state_id) if state_id
    return Company.confirmed.where("companies.id > 1") unless state_id
  end

  def self.update_customer
    Company.best.each do |c|
      c.workorders.each do |wo|
        car = wo.car
        unless car.user.service_centers.include?(c)
          car.user.service_centers << c
        end
        logger.info "### Car ID: #{car.id} WO: #{wo.id} Company: #{c.name}"
        car.save

      end
    end
  end

  def is_client?(user_id)
    Company.is_client?(self,user_id)
  end

  def self.is_client?(companies_ids,user_id)
    CompaniesUser.where("company_id IN (?) and user_id = ?",companies_ids,user_id).size > 0
  end
  
  def self.is_employee?(companies_ids,user_id)
    User.includes(:companies).where("(users.employer_id IN (?) and users.id = ?) || (companies.user_id = ?)",companies_ids,user_id,user_id).size > 0
  end

  def self.employees(companies_ids)
    User.where("employer_id IN (?)",companies_ids)
  end

  def self.clients(companies_ids,params)

    first_name = params[:first_name] || ""
    last_name = params[:last_name] || ""
    email = params[:email] || ""
    company_name = params[:company_name] || ""
    
    page = params[:page] || 1 
    clients = User.includes(:companies_users).where("companies_users.company_id in (?)", companies_ids)
    clients = clients.where("users.first_name like ?","%#{params[:first_name]}%") unless first_name.empty?
    clients = clients.where("users.last_name like ?","%#{params[:last_name]}%") unless last_name.empty?
    clients = clients.where("users.email like ?","%#{params[:email]}%") unless email.empty?
    clients = clients.where("company_name like ?","%#{params[:company_name]}%") unless company_name.empty?
    clients.order("users.last_name,users.first_name") 
  end

  def perform_service_type? st
    service_type.select{|stype| stype.id == st.id}.size > 0
  end

end

