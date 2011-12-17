class Budget < ActiveRecord::Base
  has_many :services, :dependent => :destroy
  has_many :notes

  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :brand
  belongs_to :model
  belongs_to :user
  belongs_to :car
  belongs_to :company

  accepts_nested_attributes_for :services,:reject_if => lambda { |a| a[:service_type_id].blank? }, :allow_destroy => true
  validate :service_not_empty

  validates_presence_of :first_name, :if => lambda{(user.nil? && car.nil?)}
  validates_presence_of :last_name, :if => lambda{(user.nil? && car.nil?)}


  def has_car
    (car || (domain && brand && model)) != nil
  end

  def service_not_empty
    if services.size == 0
      errors.add_to_base("El presupuesto debe contener servicios")      
    end
    c= Car.find_by_domain(domain)
    if c
      errors.add_to_base("El dominio ingresado ya existe")  
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
    
    budget = Budget.includes(:creator => :companies)
    budget = budget.where("domain like ?","%#{domain.upcase}%") if filters[:domain]
    budget = budget.includes(:services => {:material_services =>{:material_service_type =>:service_type}})
    budget = budget.order("service_types.name")
   
    
    budget = budget.where("budgets.first_name like ?","%#{filters[:first_name]}%") if filters[:first_name]
    budget = budget.where("budgets.last_name like ?","%#{filters[:last_name]}%") if filters[:last_name]
    budget = budget.where("budgets.created_at between ? and ? ",filters[:date_from].to_datetime.in_time_zone,filters[:date_to].to_datetime.in_time_zone) if (filters[:date_from] && filters[:date_to])
    
    budget = budget.where("budgets.created_at <= ? ",filters[:date_to].to_datetime.in_time_zone) if ((filters[:date_from] == nil) && filters[:date_to])
    budget = budget.where("budgets.created_at >= ? ",filters[:date_from].to_datetime.in_time_zone) if (filters[:date_from] && (filters[:date_to] == nil))
    
    if filters[:company_id]
      budget = budget.where("company_id = ?",filters[:company_id])
    else
      #workorders = workorders.where("car_id in (?)",filters[:user].cars.map{|c| c.id})
    end    
    
    budget = budget.where("services.service_type_id IN (?)",filters[:service_type_ids]) if filters[:service_type_ids]
    logger.debug "### Filters SQL #{budget.to_sql}"
    budget
  end
end
