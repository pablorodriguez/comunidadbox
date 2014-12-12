class Car < Vehicle
  validates_format_of :domain, :with => /^\D{3}\d{3}/
  validates_uniqueness_of :domain
end
