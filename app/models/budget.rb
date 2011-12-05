class Budget < ActiveRecord::Base
  has_many :services, :dependent => :destroy
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :brand
  belongs_to :model
  belongs_to :user
  belongs_to :car

  accepts_nested_attributes_for :services,:reject_if => lambda { |a| a[:service_type_id].blank? }, :allow_destroy => true
  validate :service_not_empty

  validates :first_name,:last_name,:presence => true

  def service_not_empty
    if services.size == 0
      errors.add_to_base("El presupuesto debe contener servicios")      
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def total_price
 	s_total_price=0
    self.services.each do |s|
      s_total_price += s.total_price
    end   
    s_total_price
  end
end
