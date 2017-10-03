# encoding: utf-8
class Service < ActiveRecord::Base
  acts_as_paranoid

  attr_accessible :service_type_id, :operator_id, :status, :material_services_attributes, :comment,:service_type_attributes,:vehicle_service_offer_id,:vehicle_service_offer,:status_id,:warranty
  attr_accessor :today_vehicle_service_offer

  validates :status_id, :presence => true, :unless => Proc.new { |s| s.workorder_id.nil? }

  after_initialize :init_default_value

  has_many :events,:dependent => :destroy,:inverse_of => :service
  has_and_belongs_to_many :tasks

  belongs_to :budget
  belongs_to :vehicle_service_offer
  belongs_to :service_type
  belongs_to :operator, :class_name => 'User', :foreign_key => 'operator_id'
  belongs_to :status

  # belongs_to :vehicle_service_offer
  has_many :material_services,:dependent => :destroy,:inverse_of => :service
  belongs_to :workorder, :inverse_of => :services


  accepts_nested_attributes_for :material_services, :allow_destroy => true
  accepts_nested_attributes_for :vehicle_service_offer
  accepts_nested_attributes_for :service_type

  normalize_attributes :comment

  def my_material_services
    if deleted?
      material_services.with_deleted
    else
      material_services
    end
  end

  def init_default_value
    @today_vehicle_service_offer = []
  end

  def total_price
    m_total_price=0

    if deleted?
      m = material_services.with_deleted
    else
      m= material_services
    end

    m.each do |m|
      m_total_price += m.total_price
    end

    m_total_price
  end

  def status_name
    self.status_id ? self.status.name : ""
  end

  def cancelled
    status == Status::CANCELLED
  end

  def self.find_future service
    Service.includes(:service_type,:workorder).where("service_types.id = ? and vehicle_id = ? and performed > ?
      and services.id != ?",service.service_type.id,service.workorder.vehicle.id,service.workorder.performed,service.id).order("performed desc")
  end

  def can_view_comments?(user)
    if workorder
      workorder.can_view_comments?(user)
    else
      false
    end
  end
end
