class Task < ActiveRecord::Base
  attr_accessible :name, :description
  
  validates_presence_of :description

  has_and_belongs_to_many :service_types
end

