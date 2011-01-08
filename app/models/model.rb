class Model < ActiveRecord::Base
  has_many :cars
  belongs_to :brand
  validates_presence_of :brand
end
