class Alarm < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name, :user,:date_alarm
  
  #scope :activ, lambda { |model| { :joins => :car, :conditions =>  ["cars.model_id = ?", model] } }
  scope :active, where(:status => Status::ACTIVE)  
  scope :next,lambda { |hours| where("TIMESTAMPDIFF(HOUR,NOW(),next_time) <= ?",hours)}
  scope :now, where("(date_ini <= :now and date_end >= :now) or no_end = true", :now => Time.now)
  scope :no_end, where("no_end = true")

  def self.next_minute
    where("TIMESTAMPDIFF(SECOND,:now,next_time) <= 60 and TIMESTAMPDIFF(SECOND,:now,next_time) >= 0",:now => Time.now.utc)
  end
  %W"monday tuesday wednesday thursday friday saturday sunday".each do |d|
    scope d,where(d => 1)
  end

  scope :today, Alarm.send(Time.now.strftime("%A").downcase)

  before_save :set_next_time
  

  DAYS_NAME = %W"sunday monday tuesday wednesday thursday friday saturday"
  DAYS = {}

  DAYS_NAME.each_index {|i| DAYS[i]=DAYS_NAME[i]}

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

  def init_next_time
    if is_on_time?    
      self.next_time = generate_next_time
    else
      self.next_time = nil
    end
  end

  def update_last_time
    self.last_time = Time.now
  end

  def set_next_time
    if (date_alarm_changed? || time_unit_changed? || time_changed?)
      init_next_time
      #self.next_time = generate_next_time
    end    
  end

  def generate_next_time
    d = days_selected
    if (self.time && (d.empty?))
      self.date_alarm.time + (self.time.send(self.time_unit))
    elsif (!d.empty?)
      if self.date_ini        
        next_day_selected(self.date_ini.time) 
      else
        next_day_selected(self.date_alarm.time)
      end
    else
      self.date_alarm
    end
  end

  def is_on_time?
    now = 1.minute.ago
    return true if no_end    
    if (date_ini.nil? || date_end.nil?) && (date_alarm >= now)
      return true 
    end
    
    if date_ini && date_end    
      return true if date_ini <= now && now <= date_end
    end
    return false
  end

  def is_today?
    nro = Time.now.wday
    days_selected_nro.find{|d| d == nro} != nil
  end

  def next_week_day
    nro = Time.now.wday
    DAYS[days_selected_nro.find{|d| d <= nro}]
  end

  def replay?
    return true if time
  end

  def days_selected
    days = []
    days << "sunday" if sunday
    days << "monday" if monday
    days << "tuesday" if tuesday
    days << "wednesday" if wednesday
    days << "thursady" if thursday
    days << "friday" if friday
    days << "saturday" if saturday
    days
  end

  def days_selected_nro
    days = []
    days << 0 if sunday
    days << 1 if monday
    days << 2 if tuesday
    days << 3 if wednesday
    days << 4 if thursday
    days << 5 if friday
    days << 6 if saturday
    days.sort
  end

  def next_day_selected(from=Time.now)
    days = days_selected    
    days.map{ |s| Chronic.parse("next #{s}", now: from)}.sort.first unless days.empty?    
  end

  def notify    
    logger.debug "#### notify alarm #{id}"
    self.update_last_time    
    self.save
    AlarmMailer.alarm(self).deliver
  end

  def self.notify
    logger.info "#### alarms notify called ###########"
    Alarm.next_minute.each do |alarm|        
        alarm.notify        
    end      
  end
end

