class Model < ActiveRecord::Base
  attr_accessible :brand_id, :name
  
  has_many :cars
  belongs_to :brand
  validates_presence_of :brand
end
