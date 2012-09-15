class Alarm < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name, :user
  
  scope :activ, lambda { |model| { :joins => :car, :conditions =>  ["cars.model_id = ?", model] } }
  scope :active, where(:status => Status::ACTIVE)
  scope :on_time, where("date_ini <= :now and date_end >= :now", :now => Time.now)

  %W"monday tuesday wednesday thursday friday saturday sunda".each do |d|
    scope d,where(d => 1)
  end

  scope :today, Alarm.send(Time.now.strftime("%A").downcase)

  before_save :set_next_time

  TIME_UNIT_TYPES = [
    [ 'Hs' , 'hour' ],
    [ 'Dias' , 'day' ],
    [ 'Meses' , 'month' ],
    [ 'Anos' , 'year' ]
  ]

  STATUS_TYPES = [
    [ 'Activado' , 'Active' ],
    [ 'Desactivado' , 'DeActive' ]
  ]

  def set_next_time
    if self.time
      self.next_time = generate_next_time
    end
  end

  def generate_next_time
    if self.time
      self.date_alarm + (self.time_unit.send(self.time))
    else
      self.date_alarm
    end
  end

  def self.notify
    logger.info "Envio de notificacion de alarms #{Time.now}"
  end

  def replay?
    return true if time
  end

  def days_selected
    days = []
    days << "Lunes" if monday
    days << "Martes" if tuesday
    days << "Miercoles" if wednesday
    days << "Jueves" if thursday
    days << "Viernes" if friday
    days << "Sabado" if saturday
    days << "Domingo" if sunday
    days
  end

  def self.check_alarms
    
  end
end

