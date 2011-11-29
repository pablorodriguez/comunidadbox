class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  belongs_to :state

  validates_presence_of :state,:city,:street,:zip

  acts_as_gmappable :lat => 'lat', :lng => 'lng', :process_geocoding => false

  geocoded_by :to_text, :latitude => :lat, :longitude => :lng
  after_validation :geocode

  #, :if => :street_changed?

  def gmaps4rails_title
    "#{company.name}"
  end

  def gmaps4rails_sidebar
    "#{company.name}"
  end

  def to_text
    "#{state.country.name} #{state.name} #{city} #{street}"
  end
end
