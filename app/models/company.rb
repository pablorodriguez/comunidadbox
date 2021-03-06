class Company < ActiveRecord::Base
  attr_accessible :user_id, :name, :active, :cuit, :phone, :website,:headquarter, :address_attributes,:images_attributes,:logo,:remove_logo,:code
  :payment_methods

  validates :name,:presence => true
  validates :address, :presence => true

  has_one :address
  has_one :price_list_active,:class_name=>"PriceList",:conditions=>"active=1"
  belongs_to :user
  has_many :companies_users
  has_many :customers, :through => :companies_users, :source => :user
  has_many :price_lists
  #has_many :company_service
  has_many :service_types,:order =>'name'
  has_many :workorders
  has_many :employees,:class_name =>'User',:foreign_key =>'employer_id'
  has_many :vehicles
  has_many :service_offers
  has_many :service_type_templates
  has_many :images,:dependent => :destroy,as: :imageable
  mount_uploader :logo, LogoUploader

  has_one :export
  has_one :company_attribute
  has_many :company_material_code
  has_many :payment_methods
  has_many :statuses
  has_and_belongs_to_many :models
  has_many :brands
  has_many :models,:through => :brands

  scope :confirmed, includes(:user).where("users.confirmed = 1")
  scope :not_confirmed, includes(:user).where("users.confirmed = 0")
  scope :headquarters, where("headquarter =1")


  has_many :material_requests
  DEFAULT_COMPANY_ID = 1

  accepts_nested_attributes_for :address,:reject_if => lambda {|a| a[:street].blank?},:allow_destroy => true
  accepts_nested_attributes_for :images,:reject_if => lambda {|a| a[:image].blank?},:allow_destroy => true

  before_save :update_headquarter

  def self.default_service_types
    Company.find(1).service_types
  end

  def self.default_final_status
    Company.find(1).get_final_status
  end

  def get_active_price_list
    price_list_active || user.headquarter.price_list_active
  end


  def update_headquarter
    if headquarter
      if self.persisted?
        old_hq = Company.where("user_id =? and id != ? and headquarter = ?",self.user.id,self.id, true).last
        if old_hq
          models << old_hq.models
          old_hq.models.clear
        end
      end
      Company.where("user_id =? and id != ?",self.user.id,self.id).update_all(:headquarter => false)
    end
  end

  def is_employee? usr
    return (user.id == usr.id || ((usr.employer) && (usr.employer.id == id))) ? true : false
  end

  def get_logo_url(format=:logo)
    return logo_url(format) if logo_url
    headquarter = get_headquarter
    headquarter.logo ? headquarter.logo_url(format) : ""
  end

  def get_code
    return self.code if self.code.present?
    headquarter = get_headquarter
    headquarter.code ? headquarter.code : ""
  end

  def get_headquarter
    comp = self.headquarter ? self : Company.where("user_id = ? AND headquarter = 1",self.user.id).first
    comp = self unless comp
    comp
  end

  def is_logo(image)
    logo && (logo.id == image.id)
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
    self.employees.enabled.includes(:roles).where("roles.name = ?",Role::OPERATOR).order("users.first_name,users.last_name")
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
    company_vehicles = Vehicle.where("company_id = ?",id)
    vehicles_ids = company_vehicles.each{|c|c.id.to_i}
    Event.all(:conditions => ["dueDate >= ? and vehicle_id in(?)", Time.zone.now,vehicles_ids])
  end

  def self.best(state_id = nil)
    return Company.confirmed.includes(:address).where("addresses.state_id = ? and companies.id > 1",state_id) if state_id
    return Company.confirmed.where("companies.id > 1") unless state_id
  end

  def self.update_customer
    Company.best.each do |c|
      c.workorders.each do |wo|
        vehicle = wo.vehicle
        unless vehicle.user.service_centers.include?(c)
          vehicle.user.service_centers << c
        end
        logger.info "### Vehicle ID: #{vehicle.id} WO: #{wo.id} Company: #{c.name}"
        vehicle.save

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

  def self.employees(companies_ids,employee_search)
    #email = params[:email] || ""
    #first_name = params[:first_name] || ""
    #last_name = params[:last_name] || ""
    roles_ids = employee_search.roles ? employee_search.roles.map{|v|v.to_i} : []
    active = employee_search.status || "active"

    emp = User.where("employer_id IN (?)",companies_ids)
    if  active == "active"
      emp = emp.where("disable is NULL")
    elsif active == "deleted"
      emp = emp.where("disable = 1")
    end

    if  roles_ids.size > 0
      emp = emp.includes(:roles).where("roles.id in (?)",roles_ids)
    end

    emp = emp.where("email like ?","%#{employee_search.email}%") if employee_search.email
    emp = emp.where("first_name like ?","%#{employee_search.first_name}%") if employee_search.first_name
    emp = emp.where("last_name like ?","%#{employee_search.last_name}%") if employee_search.last_name
    emp

  end

  def self.clients(params)
    clients = User.includes(:companies_users).where("companies_users.company_id in (?)", params[:companies_ids])
    clients = clients.where("users.first_name like ?","%#{params[:first_name]}%") if params[:first_name]
    clients = clients.where("users.last_name like ?","%#{params[:last_name]}%") if params[:last_name]
    clients = clients.where("users.email like ?","%#{params[:email]}%") if params[:email]
    clients = clients.where("users.company_name like ?","%#{params[:company_name]}%") if params[:company_name]

    clients = clients.where("DATE(users.created_at) >= ?",date_f.to_date) if params[:date_f]
    clients = clients.where("DATE(users.created_at) <= ?",date_t.to_date) if params[:date_t]
    clients.order("users.created_at DESC")
  end

  def perform_service_type? st
    service_types.select{|stype| stype.id == st.id}.size > 0
  end

  def self.clients_to_csv(filePath, company_id)
    params = {}
    clients = self.clients([company_id],params).limit(30)

    CSV.open(filePath, "w+",{:col_sep => ","}) do |csv|
      csv << ['id', 'first_name','last_name','email','company_name','cuit', 'phone','created_at','updated_at','vehicle_domain','vehicle_brand','vehicle_model','vehicle_year','vehicle_fuel','vehicle_km']

      clients.each do |client|
        print '.'

        user_row = [client.id, client.first_name, client.last_name, client.email, client.company_name, client.cuit, client.phone, client.created_at, client.updated_at]

        if client.vehicles.blank?
          csv << user_row
        else
          client.vehicles.each do |vehicle|
            row = user_row.clone
            row = row + [vehicle.domain, vehicle.brand.name, vehicle.model.name, vehicle.year, vehicle.fuel, vehicle.km]
            csv << row
          end
        end
      end
      puts '.'

    end

  end

  def self.clients_report_to_csv(companies_ids,params)
    cList = clients companies_ids, params

    CSV.generate do |csv|
      csv << [I18n.t('client_id'),I18n.t('last_name'),I18n.t('first_name'),I18n.t('company_name'),I18n.t('email'),I18n.t('phone'),I18n.t('creator'),I18n.t('vehicle_domain'),I18n.t('vehicle_brand'),I18n.t('vehicle_model'),I18n.t('vehicle_year')]

      if cList.present?
        cList.each do |client|

          client_fd = true
          row_client = [client.id, nil, nil, nil, nil, nil, nil]
          row_client_fd = [client.id, client.last_name, client.first_name, client.company_name, client.email, client.phone]

          client.creator ? row_client_fd += [client.creator.company.name] : row_client_fd += [nil]

          if client.vehicles.blank?
            csv << row_client_fd
          else
            client.vehicles.each do |vehicle|
              row_vehicle = [vehicle.domain, vehicle.brand.name, vehicle.model.name, vehicle.year]

              if client_fd
                csv << row_client_fd + row_vehicle
                client_fd = false
              else
                csv << row_client + row_vehicle
              end
            end
          end

        end
      end
    end
  end

  def available_payment_methods
    payment_methods.any? ? payment_methods.active : get_headquarter.payment_methods.active
  end

  def available_custom_statuses
    statuses.any? ? statuses : get_headquarter.statuses
  end

  def get_final_status
    final_status = statuses.where(is_final: true).first
    unless final_status
      return user.headquarter.get_final_status
      # revisar esta parte
      if user.headquarter != user.company_active
        final_status = user.headquarter.get_final_status
      end
    end
    final_status
  end

  def get_brands
    get_headquarter.brands
  end

  def get_models
    get_headquarter.models
  end

  def headquarter_models_by_brand(brand)
    get_headquarter.models.where(brand_id: brand.id)
  end

  def assign_model_to_headquarter(model_id, add_to_company)
    hq = get_headquarter
    model = Model.find(model_id)
    if model
      if add_to_company
          hq.models << model if !hq.models.exists?(model)
      else
        hq.models.delete(model)
      end
    end
  end

  def remove_brand_model_of_headquarters(brand)
    hq = get_headquarter
    hq.models.delete(headquarter_models_by_brand(brand))
  end

  def control_material?
    self.company_attribute.material_control
  end
end

