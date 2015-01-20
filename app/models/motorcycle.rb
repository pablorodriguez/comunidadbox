# encoding: utf-8
class Motorcycle < Vehicle
  attr_accessible :chassis

  validates_format_of :domain, :with => /^\d{3}\D{3}/

end
