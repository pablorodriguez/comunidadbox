class Brand < ActiveRecord::Base
  has_many :cars
  has_many :models
end
