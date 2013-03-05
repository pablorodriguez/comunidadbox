class Rank < ActiveRecord::Base
  attr_accessible :cal, :type_rank, :workorder_id, :comment
  
  validates_numericality_of :cal,:message => "Calificacion debe ser un numero entre 1 y 5",:greater_than_or_equal_to => 1 ,:less_than_or_equal_to=>5
  belongs_to :workorder
  
  VALUES = {
    1 => "Muy Malo",
    2 => "Malo",
    3 => "Bueno",
    4 => "Muy Bueno",
    5 => "Excelente"
  }

  COMPANY = 1
  USER = 2
  
  TYPES = {
    COMPANY => "Company",
    USER => "User"
  }


  def self.rank_type(user)
    user.company ? COMPANY : USER
  end
  
end
