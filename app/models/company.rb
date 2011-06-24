class Company < ActiveRecord::Base
  has_one :address
  belongs_to :user
  has_many :price_lists
  has_one :price_list_active,:class_name=>"PriceList",:conditions=>"active=1"
  has_many :company_service
  has_many :service_type, :through => :company_service, :order =>'name'
  has_many :workorders
  has_many :employees,:class_name =>'User',:foreign_key =>'employer_id'
  has_many :cars
  has_many :service_offers
  
  DEFAULT_COMPANY_ID = 1
  
  accepts_nested_attributes_for :address,:reject_if => lambda {|a| a[:street].blank?},:allow_destroy => true
  
  def is_employee user
    return (self.user == user || employees.select{|e| e.id == user.id}.size > 0) ? true : false
  end
  
  def full_address
    address ? "#{address.street} #{address.city} #{address.state.name}" : ""
  end
  def admin_user
    self.users.select{|u| u.is_company_admin}[0]
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
    total_wo = self.workorders.size
    rank = 0
    self.workorders.each do |wo|
      if wo.user_rank
        rank += wo.user_rank.cal  
      end
      
    end
    if total_wo == 0
       return 0
    else
      (rank.to_f / total_wo)
    end
    
  end
  
  def total_work_order
    self.workorders.size
  end
  
  def total_user_ranked
    total = 0
    if self.workorders
      self.workorders.each do |wo|
        if wo.user_rank
          total +=1  
        end      
      end
    end
    total
  end
  
  def future_events
    company_cars = Car.all(:conditions =>["company_id = ?",id])
    cars_ids = company_cars.each{|c|c.id.to_i}
    Event.all(:conditions=>["dueDate >= ? and car_id in(?)",Time.now,cars_ids])
  end
  
end
