class Alarm < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name, :user, :time

  validates_numericality_of :time

  TIME_UNIT_TYPES = [
    [ 'Hs' , 'Hs' ],
    [ 'Dias' , 'Dias' ],
    [ 'Meses' , 'Meses' ],
    [ 'Anos' , 'Anos' ]
  ]

  STATUS_TYPES = [
    [ 'Activado' , 'Activado' ],
    [ 'Desactivado' , 'Desactivado' ]
  ]
  
end

