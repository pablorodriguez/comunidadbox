# encoding: utf-8
class Budget < ActiveRecord::Base
  attr_accessible :first_name,:last_name,:phone,:email,:domain,:brand_id,:model_id,:vehicle_type,:chassis, :vehicle_id, :user_id,:comment,:services_attributes,:service_type_attributes

  has_many :services, :dependent => :destroy
  has_many :notes, :order => "CREATED_AT desc"
  has_many :workorders

  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :brand
  belongs_to :model
  belongs_to :user
  belongs_to :vehicle
  belongs_to :company
  belongs_to :status


  scope :companies, lambda { |comp_id| {:conditions =>  ["company_id IN (?)", comp_id] } }
  default_scope order("budgets.created_at DESC")

  accepts_nested_attributes_for :services,:reject_if => lambda { |a| a[:service_type_id].blank? }, :allow_destroy => true

  validate :service_not_empty


  def has_vehicle
    (vehicle || (domain && brand && model)) != nil
  end

  def has_client?
    user != nil
  end

  def service_not_empty
    if services.empty?
      errors[:base] << I18n.t(".must_have_services")
      #{}"El presupuesto debe contener servicios"
    end

    #busco auto con el mismo dominio
    #c= Vehicle.find_by_domain(domain)
    # si lo encuentro y el budget no tiene un auto => agrego error
    # si lo encuentro y el budget tiene auto cuyo user es distinto al user del auto encontrado => agrego error
    #if (c && vehicle.nil?) || (c && vehicle && vehicle.user.id != c.user.id)
    #  errors[:base] << "El dominio ingresado ya existe"
    #end

    if email && user.nil?
      #busco usuario con el mismo email
      u = User.find_by_email(email.strip)
      # si lo encuentro y el budget no tiene usuario => agrego error
      # si lo encuentro y el budget tine usuario cuyo id es distinto al id del usuario encontrado con el mismo email => agrego error
      if (u && user.nil?) || (u && user && u.id != user.id)
        errors[:base] << "El email ingresado ya existe"
      end
    end

    # si el budget tiene usuario y auto y el auto no pertenece al usuario => agrego error
    if vehicle && user
      if vehicle.user.id != user.id
        errors[:base] <<  I18n.t(".vehicle_not_user")
      end
    end

  end

  def full_name
    name = "#{first_name} #{last_name}" unless user
    name = "#{user.first_name} #{user.last_name}" if user
    name = "#{vehicle.user.first_name} #{vehicle.user.last_name}" if vehicle
    name
  end

  def vehicle_domain
    ""
    "#{domain}" if domain
    "#{vehicle.domain}" if vehicle
  end

  def brand_name
    brand ? brand.name : ""
  end

  def model_name
    model ? model.name : ""
  end

  def total_price
 	s_total_price=0
    self.services.each do |s|
      s_total_price += s.total_price
    end
    s_total_price
  end

  def self.find_by_params(filters)
    domain =  filters[:domain] || ""
    budget = Budget.includes(:vehicle => :user).includes(:creator => :companies,:services => [{:material_services =>[{:material_service_type =>:service_type}]}])

    prop = %w"domain brand_id model_id year first_name last_name date_from date_to"
    unless prop.any?{|k| filters.key?(k.to_sym)}
      budget = budget.joins('LEFT OUTER JOIN workorders ON workorders.budget_id = budgets.id').where("workorders.budget_id IS NULL")
    else
      budget = budget.where("vehicles.domain like :domain or  budgets.domain like :domain",{domain: "%#{domain.upcase}%"}) if filters[:domain]
      budget = budget.where("budgets.brand_id = :brand_id OR vehicles.brand_id = :brand_id",{brand_id: "#{filters[:brand_id]}"}) if filters[:brand_id]
      budget = budget.where("budgets.model_id = :model_id OR vehicles.model_id = :model_id",{model_id: "#{filters[:model_id]}"}) if filters[:model_id]
      budget = budget.where("vehicles.year = ?","#{filters[:year]}") if filters[:year]

      budget = budget.where("budgets.first_name like :name OR users.first_name like :name",{name: "%#{filters[:first_name]}%"}) if filters[:first_name]
      budget = budget.where("budgets.last_name like :name OR users.last_name like :name ",{name: "%#{filters[:last_name]}%"}) if filters[:last_name]
      budget = budget.where("budgets.created_at between ? and ? ",filters[:date_from].to_datetime.in_time_zone,filters[:date_to].to_datetime.in_time_zone) if (filters[:date_from] && filters[:date_to])

      budget = budget.where("budgets.created_at <= ? ",filters[:date_to].to_datetime.in_time_zone) if ((filters[:date_from] == nil) && filters[:date_to])
      budget = budget.where("budgets.created_at >= ? ",filters[:date_from].to_datetime.in_time_zone) if (filters[:date_from] && (filters[:date_to] == nil))
    end

    if filters[:company_id]
      budget = budget.where("budgets.company_id IN (?)",filters[:company_id])
    else
      budget = budget.where("budgets.user_id = ?",filters[:user].id)
    end

    budget = budget.where("budgets.id = ?",filters[:budget_id].to_i) if filters [:budget_id]


    budget = budget.where("services.service_type_id IN (?)",filters[:service_type_ids]) if filters[:service_type_ids]

    budget
  end

  def can_show?(user)
    (self.vehicle && self.vehicle.user == user) || self.user == user || self.company.is_employee?(user)
  end

  def can_edit? user
    creator.id == user.id || company.is_employee?(user)
  end

  def can_create_service? user
    ((user && vehicle) || (user.nil? && vehicle.nil?)) && user.company
  end

  def can_send_message? usr
    if usr.is_employee?
      if self.user && self.user.id != nil
        return true
      else
        return false
      end
    end
    return true
  end

  def self.to_csv(filePath, company_id)
    filters_params = {}
    filters_params[:company_id] = company_id
    budgets = find_by_params(filters_params).limit(30)


    CSV.open(filePath, "w+",{:col_sep => ","}) do |csv|
      csv << csv_column_names

      budgets.each do |budget|

        bg_values = csv_budget_row_values(budget)

        budget.services.each do |service|
          bg_service_values = bg_values.clone + [service.service_type.name]

          service.material_services.each do |mat_service|
            row = bg_service_values.clone + [mat_service.material_detail, mat_service.amount, mat_service.price]
            csv << row
          end

        end
      end
    end
  end

  def self.csv_column_names
    ["id","company","customer","customer_phone","customer_email","vehicle_domain","vehicle_brand","vehicle_model","comment","created_at","updated_at","service","material","material_amount","material_price"]
  end

  def self.csv_budget_row_values(budget)
    print '.'
    bg_values = []
    bg_values << budget.id
    bg_values << budget.company.name
    bg_values << budget.full_name

    if budget.user.present?
      bg_values << budget.user.phone
      bg_values << budget.user.email
    elsif budget.vehicle.present?
      bg_values << budget.vehicle.user.phone
      bg_values << budget.vehicle.user.email
    else
      bg_values << budget.phone
      bg_values << budget.email
    end


    if budget.vehicle.present?
      bg_values << budget.vehicle.domain
      bg_values << budget.vehicle.brand.name
      bg_values << budget.vehicle.model.name
    else
      bg_values << budget.domain
      bg_values << budget.brand_name
      bg_values << budget.model_name
    end

    bg_values << budget.comment
    bg_values << budget.created_at
    bg_values << budget.updated_at

  end

  def self.budget_report_to_csv(params)
    bList = find_by_params params

    CSV.generate do |csv|
      csv << [I18n.t('budget'), I18n.t('vehicle'), I18n.t('client'), I18n.t('operator'), I18n.t('budget_date'), I18n.t('budget_price'), I18n.t('service_id'), I18n.t('service'), I18n.t('service_price'), I18n.t('material_amount'), I18n.t('material_price'), I18n.t('material_total_price'), I18n.t('material_code'), I18n.t('material_prov_code'), I18n.t('material')]

      if bList.present?
        bList.each do |b|
          budget = Budget.find b.id #para obtener el presupuesto completo

          budget_fd = true
          row_budget = [budget.id, nil, nil, nil, nil, nil]
          row_budget_fd = [budget.id, budget.vehicle_domain, budget.full_name, budget.creator.full_name, I18n.l(budget.created_at, :format => :short), budget.total_price]

          budget.services.each do |service|
            service_fd = true
            row_service = [service.service_type.id, service.service_type.name, nil]
            row_service_fd = [service.service_type.id, service.service_type.name, service.total_price]

            if(service.material_services.present?)
              service.material_services.each do |mat_service|
                if budget_fd
                  row = row_budget_fd
                  budget_fd = false
                else
                  row = row_budget
                end

                row_material = [mat_service.amount, mat_service.price, mat_service.total_price, mat_service.material_code, mat_service.material_prov_code, mat_service.material_name]

                if service_fd
                  csv << row + row_service_fd + row_material
                  service_fd = false
                else
                  csv << row + row_service + row_material
                end
              end
            else
              if budget_fd
                row = row_budget_fd
                budget_fd = false
              else
                row = row_budget
              end
              csv << row + row_service_fd
            end
          end
        end
      end
    end
  end

  def self.service_types_for user,company_ids
    st = ServiceType.joins(:services => :budget)
    st = st.where("budgets.company_id IN(?)",company_ids)if company_ids
    st = st.where("budgets.user_id = ?",user.id) unless company_ids
    st = st.group("service_types.id")
    st
  end

end