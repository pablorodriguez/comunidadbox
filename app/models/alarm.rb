# encoding: utf-8
class Alarm < ActiveRecord::Base
  attr_accessible :name, :status, :description, :date_alarm, :time, :time_unit, :date_ini, :date_end, :no_end, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday

  belongs_to :user
  belongs_to :client, :class_name => 'User', :foreign_key => 'client_id'
  belongs_to :vehicle, :class_name => 'Vehicle', :foreign_key => 'vehicle_id'
  belongs_to :event
  belongs_to :company

  has_many :messages
  has_many :notes

  validates_presence_of :name, :user,:date_alarm

  #scope :activ, lambda { |model| { :joins => :vehicle, :conditions =>  ["vehicles.model_id = ?", model] } }
  scope :active, where(:status => Status::ACTIVE)
  scope :next,lambda { |hours| where("TIMESTAMPDIFF(HOUR,NOW(),next_time) <= ?",hours)}
  scope :now, where("(date_ini <= :now and date_end >= :now) or no_end = true", :now => Time.zone.now)
  scope :no_end, where("no_end = true")

  def self.next_minute
    where("TIMESTAMPDIFF(SECOND,:now,next_time) <= 60 and TIMESTAMPDIFF(SECOND,:now,next_time) >= 0",:now => Time.zone.now)
  end


  %W"monday tuesday wednesday thursday friday saturday sunday".each do |d|
    scope d,where(d => 1)
  end

  scope :today, Alarm.send(Time.zone.now.strftime("%A").downcase)
  scope :run_in_next_hours,lambda{|hrs| where("next_time  BETWEEN ? AND ?",1.minute.ago,hrs.hours.since)}

  before_save :set_next_time


  DAYS_NAME = %W"sunday monday tuesday wednesday thursday friday saturday"
  DAYS = {}

  DAYS_NAME.each_index {|i| DAYS[i]=DAYS_NAME[i]}

  TIME_UNIT_TYPES = [
    [ 'Hs' , 'hour' ],
    [ I18n.t("days") , 'day' ],
    [ I18n.t("months") , 'month' ],
    [ I18n.t("years") , 'year' ]
  ]

  STATUS_TYPES = [
    [ 'Activado' , 'Active' ],
    [ 'Desactivado' , 'DeActive' ]
  ]


  def init_next_time
    self.next_time = generate_next_time

    #se the companyt if the user have one
    self.company_id = self.user.company_id if self.user.company_id
  end

  def update_next_time
    if (no_end || (date_end && date_end >= Time.zone.now))
      self.next_time = generate_next_time(self.next_time)
    else
      self.next_time = nil
      self.status =Status::CANCELLED
    end
  end

  def update_last_time
    self.last_time = Time.zone.now
  end

  #Update next time when alarm is saved
  def set_next_time
    if (date_alarm_changed? || time_unit_changed? || time_changed?)
      init_next_time
    end
  end

  def generate_next_time(base_time= self.date_alarm)
    d = days_selected
    if (self.time && (d.empty?))
        new_time = base_time + (self.time.send(self.time_unit))
    elsif (!d.empty?)
      if self.date_ini
        new_time = next_day_selected(self.date_ini)
      else
        new_time = next_day_selected(self.date_alarm)
      end
    else
      new_time = self.date_alarm
    end
    new_time.utc
  end

  #check if the alarm is on time
  def is_on_time?
    now = Time.zone.now
    return true if no_end
    if (date_ini.nil? || date_end.nil?) && (date_alarm >= now)
      return true
    end

    return true if date_end >= now
    return false
  end

  def is_today?
    nro = date_alarm.wday
    days_selected_nro.find{|d| d == nro} != nil
  end

  def next_week_day
    nro = Time.zone.now.wday
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
    days << "thursday" if thursday
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

  def next_day_selected(from=Time.zone.now)
    if (is_today? && (date_alarm > Time.zone.now))
      date_alarm
    else
      days = days_selected
      days.map{ |s| Chronic.parse("next #{s}", now: from)}.sort.first unless days.empty?
    end
  end

  def alarm_text
    "Alarma: #{name} , #{description}"
  end

  def notify
    logger.info "#### notify alarm #{id} #{Time.zone.now}"
    update_next_time
    update_last_time
    send_message
    save
  end

  def send_message
    msg = Message.new
    msg.message = alarm_text
    msg.alarm = self
    msg.user = user
    msg.receiver = user
    msg.save
  end


  def deliver_notify
    notify
    AlarmMailer.alarm(self).deliver
  end

  def self.notify
    logger.debug "#{Time.zone.now} alarms notify called ###########"
    Alarm.next_minute.each do |alarm|
      alarm.deliver_notify
    end
  end

  def self.for_event_end_user(event,user)
    Alarm.where("event_id = ? && company_id IN (?)",event.id,user.get_companies_ids)
  end
end

