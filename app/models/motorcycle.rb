# encoding: utf-8
class Motorcycle < Vehicle
  has_one :vehicle_motorcycle, dependent: :destroy

  accepts_nested_attributes_for :vehicle_motorcycle

  default_scope includes(:vehicle_motorcycle)

  delegate :chassis, to: :vehicle_motorcycle, prefix: false

  validates_format_of :domain, :with => /^\d{3}\D{3}/

end
