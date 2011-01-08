class Rank < ActiveRecord::Base
  validates_presence_of :comment,:message => "Este Comentario es obligatorio"
  validates_numericality_of :cal,:message => "Calificacion debe ser un numero entre 0 y 5",:greater_than_or_equal_to => 0 ,:less_than_or_equal_to=>5
end
