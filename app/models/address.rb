class Address < ActiveRecord::Base
  attr_accessible :state_id, :lat, :lng, :city, :street, :zip,:state

  belongs_to :user
  belongs_to :company
  belongs_to :state

  validates_presence_of :state
  
  acts_as_gmappable :lat => 'lat', :lng => 'lng', :process_geocoding => false

  #geocoded_by :to_text, :latitude => :lat, :longitude => :lng

  #after_validation :geocode
  scope :companies, where("company_id is not null")

  #, :if => :street_changed?

  def gmaps4rails_title
    "#{company.name}"
  end

  def gmaps4rails_sidebar
    "#{company.name}"
  end

  def to_text
    if state && state.country && street
      "#{state.country.name} #{state.name} #{city} #{street}" 
    else
      ""
    end

  end
end
