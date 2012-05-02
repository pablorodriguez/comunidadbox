class Budget < ActiveRecord::Base
  has_many :services, :dependent => :destroy
  has_many :notes

  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :brand
  belongs_to :model
  belongs_to :user
  belongs_to :car
  belongs_to :company

  scope :companies, lambda { |comp_id| {:conditions =>  ["company_id IN (?)", comp_id] } }

  accepts_nested_attributes_for :services,:reject_if => lambda { |a| a[:service_type_id].blank? }, :allow_destroy => true
  validate :service_not_empty

  validates_presence_of :first_name, :if => lambda{(user.nil? && car.nil?)}
  validates_presence_of :last_name, :if => lambda{(user.nil? && car.nil?)}


  def has_car
    (car || (domain && brand && model)) != nil
  end

  def service_not_empty
    if services.empty?
      errors.add_to_base("El presupuesto debe contener servicios")      
    end
    
    #busco auto con el mismo dominio
    c= Car.find_by_domain(domain)   
    # si lo encuentro y el budget no tiene un auto => agrego error
    # si lo encuentro y el budget tiene auto cuyo user es distinto al user del auto encontrado => agrego error 
    if (c && car.nil?) || (c && car && car.user.id != c.user.id)
      errors.add_to_base("El dominio ingresado ya existe")  
    end  

    if email && user.nil?
      #busco usuario con el mismo email
      u = User.find_by_email(email.strip)
      # si lo encuentro y el budget no tiene usuario => agrego error
      # si lo encuentro y el budget tine usuario cuyo id es distinto al id del usuario encontrado con el mismo email => agrego error
      if (u && user.nil?) || (u && user && u.id != user.id)
        errors.add_to_base("El email ingresado ya existe")  
      end
    end

    # si el budget tiene usuario y auto y el auto no pertenece al usuario => agrego error
    if car && user
      if car.user.id != user.id
        errors.add_to_base("El automovil no pertenece al usuario")  
      end
    end
  
  end

  def full_name
    name = "#{first_name} #{last_name}" unless user
    name = "#{user.first_name} #{user.last_name}" if user
    name = "#{car.user.first_name} #{car.user.last_name}" if car
    name
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
    
    budget = Budget.includes(:car,:creator => :companies)    
    budget = budget.where("cars.domain like ? or  budgets.domain like ?","%#{domain.upcase}%","%#{domain.upcase}%") if filters[:domain]
    budget = budget.includes(:services => {:material_services =>{:material_service_type =>:service_type}})
    budget = budget.order("budgets.created_at DESC")
   
    budget = budget.where("budgets.brand_id = ? OR cars.brand_id = ?","#{filters[:brand_id]}","#{filters[:brand_id]}") if filters[:brand_id]
    budget = budget.where("budgets.model_id = ? OR cars.model_id = ?","#{filters[:model_id]}","#{filters[:model_id]}") if filters[:model_id]
    budget = budget.where("cars.year = ?","#{filters[:year]}") if filters[:year]

    budget = budget.where("budgets.first_name like ?","%#{filters[:first_name]}%") if filters[:first_name]
    budget = budget.where("budgets.last_name like ?","%#{filters[:last_name]}%") if filters[:last_name]
    budget = budget.where("budgets.created_at between ? and ? ",filters[:date_from].to_datetime.in_time_zone,filters[:date_to].to_datetime.in_time_zone) if (filters[:date_from] && filters[:date_to])
    
    budget = budget.where("budgets.created_at <= ? ",filters[:date_to].to_datetime.in_time_zone) if ((filters[:date_from] == nil) && filters[:date_to])
    budget = budget.where("budgets.created_at >= ? ",filters[:date_from].to_datetime.in_time_zone) if (filters[:date_from] && (filters[:date_to] == nil))
    
    if filters[:company_id]
      budget = budget.where("budgets.company_id IN (?)",filters[:company_id])
    else
      budget = budget.where("user_id = ?",filters[:user].id)
    end    
    
    budget = budget.where("services.service_type_id IN (?)",filters[:service_type_ids]) if filters[:service_type_ids]
    logger.debug "### Filters SQL #{budget.to_sql}"
    budget
  end

  def can_edit? user
    creator.id == user.id
  end

  def can_create_service? user
    ((user && car) || (user.nil? && car.nil?)) && user.company
  end

end
