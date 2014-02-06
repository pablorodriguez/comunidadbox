class ServiceRequest < ActiveRecord::Base
  attr_accessible :car_id, :company_id, :status, :user_id,:item_service_requests_attributes

  has_many :item_service_requests
  has_many :service_types,:through => :item_service_requests
  has_many :service_offers
  belongs_to :user
  belongs_to :company
  belongs_to :car

  default_scope order("service_requests.created_at DESC")
  scope :confirmed, where("status = ?",Status::CONFIRMED)
  scope :user, lambda { |user| where("user_id = ?",user.id)}
  accepts_nested_attributes_for :item_service_requests,:reject_if => lambda { |m| m[:service_type_id].blank? }, :allow_destroy => true


  validates_presence_of :user,:car

  def car_service_offers
    CarServiceOffer.where("service_offer_id IN (?) and car_id = ?",service_offers.map(&:id),car.id)
  end

  def self.for_user user
    if user.company_active
      ServiceRequest.confirmed
    else
      ServiceRequest.user(user)
    end
  end

  def can_edit? usr
    self.user == usr && self.status == Status::OPEN
  end

  def can_delete? usr    
    self.user.id == usr.id
  end

  def to_builder
    Jbuilder.encode do |json|  
      json.(self,:id)
      json.car(self.car,:id,:domain) if self.car
      unless car
        json.car do
          json.id ""
          json.domain ""
        end
      end
      json.item_service_requests self.item_service_requests do |isr|           
        json.id isr.id
        json.description isr.description
        json.show true
        json.service_type do
          json.id isr.service_type.id
          json.name isr.service_type.name
        end  
      end
    end
  end 

  
end
