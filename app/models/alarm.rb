class Alarm < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name, :user


  TIME_UNIT_TYPES = [
    [ 'Hs' , 'Hs' ],
    [ 'Dias' , 'Dias' ],
    [ 'Meses' , 'Meses' ],
    [ 'Anos' , 'Anos' ]
  ]

  STATUS_TYPES = [
    [ 'Activado' , 'Active' ],
    [ 'Desactivado' , 'DeActive' ]
  ]
  
end

