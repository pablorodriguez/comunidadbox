class Rank < ActiveRecord::Base
  attr_accessible :cal, :type_rank, :workorder_id, :comment
  
  validates_numericality_of :cal,:message => "Calificacion debe ser un numero entre 0 y 5",:greater_than_or_equal_to => 0 ,:less_than_or_equal_to=>5
  belongs_to :workorder
  
  VALUES = {
    1 => "Muy Malo",
    2 => "Malo",
    3 => "Bueno",
    4 => "Muy Bueno",
    5 => "Excelente"
  }
  
  TYPES = {
    1 => "Company",
    2 => "User"
  }
  
end
