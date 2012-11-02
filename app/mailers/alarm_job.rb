class AlarmJob
  @queue = :alarms
  
  class << self
    def perform
      Alarm.notify      
    end
  end
end