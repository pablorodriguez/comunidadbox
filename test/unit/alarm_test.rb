require 'test_helper'

class AlarmTest < ActiveSupport::TestCase
  
  setup do
    create_all_default_data    
  end

  test "validate alarm generated" do
    @alarm =  create(:alarm_repit)
    assert(@alarm.next_time == @alarm.date_alarm, "Next time no es correcto")
  end

  test "validate next time alarm" do
    now = Time.now
    next_time = now + 1.hour
    debugger
    @alarm =  create(:alarm_repit,:name=> "alarm each 1 hour",:time => 1,:time_unit => "hour",:date_alarm => now,:date_ini => now,:date_end => 1.month.since)
    
    assert(@alarm.next_time == next_time,"Next time no es correcto")
  end

  test "validate no end alarm" do
    now = 1.month.since
    next_time = (now + 1.hour).utc
    unit_time = "hour"
    @alarm =  create(:alarm_repit,:name=> "alarm each 1 hour no end",:time => 1,:time_unit =>unit_time,:date_alarm => now,:no_end => true)
    assert(@alarm.next_time.time == next_time,"Next time no es correcto: #{@alarm.next_time.time} != #{next_time}")
  end

  test "validate next time do not change" do
    now = 1.month.since
    next_time = (now + 1.month).utc
    unit_time = "month"
    @alarm =  create(:alarm_repit,:name=> "alarm each 1 month no end",:time => 1,:time_unit => unit_time,:date_alarm => now,:no_end => true)
    assert(@alarm.next_time.time == next_time,"Next time no es correcto: #{@alarm.next_time.time} != #{next_time}")
    @alarm.update_attribute(:name,"new name")
    assert(@alarm.next_time.time == next_time,"Next time no es correcto: #{@alarm.next_time.time} != #{next_time}")    
  end

  test "validate next time change 1 month" do
    now = 1.month.since.time
    next_time = now + 1.month
    unit_time = "month"
    @alarm =  create(:alarm_repit,:name=> "alarm month no end",:time => 1,:time_unit => unit_time,:date_alarm => now,:no_end => true)
    assert(@alarm.next_time.time == next_time,"Next time no es correcto: #{@alarm.next_time.time} != #{next_time}")    
    @alarm.update_attribute(:date_alarm,next_time)
    new_next_time = next_time + 1.month
    assert(@alarm.next_time.time == new_next_time ,"Next time no es correcto despues de cambiar date_alarm: #{@alarm.date_alarm} #{@alarm.next_time.time} != #{new_next_time}")
  end

  test "validate next time change 1 hours" do
    now = 1.month.since.time
    next_time = now + 1.month
    unit_time = "month"
    @alarm =  create(:alarm_repit,:name=> "alarm month no end",:time => 1,:time_unit => unit_time,:date_alarm => now,
      :no_end => true)
    assert(@alarm.next_time.time == next_time,"Next time no es correcto: #{@alarm.next_time.time} != #{next_time}")    
    @alarm.update_attribute(:time_unit,"hour")
    new_next_time = now + 1.hour
    assert(@alarm.next_time.time == new_next_time ,"Next time no es correcto despues de cambiar 
        Date Alarm: #{@alarm.date_alarm} 
        Next Time: #{@alarm.next_time.time} !=  New Next Time: #{new_next_time}")
  end

  test "validate next time change each day" do
    now = 1.day.since.time
    next_time = now + 1.day
    unit_time = "day"
    @alarm =  create(:alarm_repit,:name=> "alarm month no end",:time => 1,:time_unit => unit_time,:date_alarm => now,
      :no_end => true)
    assert(@alarm.next_time.time == next_time,"Next time no es correcto: #{@alarm.next_time.time} != #{next_time}")    
  end

  test "validate next time change year day" do
    now = 1.day.since.time
    next_time = now + 1.year
    unit_time = "year"
    @alarm =  create(:alarm_repit,:name=> "alarm month no end",:time => 1,:time_unit => unit_time,:date_alarm => now,
      :no_end => true)
    assert(@alarm.next_time.time == next_time,"Next time no es correcto: #{@alarm.next_time.time} != #{next_time}")    
  end

  test "validate next time each monday" do
    now = Time.now
    next_time = Chronic.parse("next monday")    
    unit_time = "week"
    @alarm =  create(:alarm_repit,:time => 1,:time_unit => unit_time,:date_alarm => now,:no_end => true,:monday=>true)    
    assert(@alarm.next_time.time == next_time,"Next time no es correcto: 
        Alarm Next Time: #{@alarm.next_time.time} 
        Next Time: #{next_time}")    
  end

  test "validate next time each friday" do
    now = Chronic.parse("next monday") + 1.day
    next_time = Chronic.parse("next friday", now: now)
    unit_time = "week"
    @alarm =  create(:alarm_repit,:time => 1,:time_unit => unit_time,:date_alarm => now,:no_end => true,monday: true, friday: true)    
    assert(@alarm.next_time.time == next_time,"Next time no es correcto: 
        Alarm Next Time: #{@alarm.next_time.time} 
        Next Time: #{next_time}")    
  end

  test "validate next time each friday with date ini" do
    
    now = Time.new(2012,10,30)
    date_ini = Time.new(2012,11,30)
    date_end = date_ini + 1.month
    next_time = Chronic.parse("2012-12-3")
        
    @alarm =  create(:alarm_repit,:date_alarm => now,:no_end => true,:date_ini => date_ini ,:date_end => date_end,monday: true, friday: true)    
    
    assert(@alarm.next_time == next_time.utc,"Next time no es correcto: 
        Alarm Next Time: #{@alarm.next_time.time} 
        Next Time: #{next_time}")    
  end

  test "validate next time for invalid alarm" do
    
    now = Time.new(2012,10,30)
    date_ini = Time.new(2012,5,30)
    date_end = date_ini + 1.month
    next_time = Chronic.parse("2012-12-3")
        
    @alarm =  create(:alarm_repit,:date_alarm => now,:date_ini => date_ini ,:date_end => date_end,monday: true, friday: true)        
    assert_nil(@alarm.next_time,"Next time no es null")    
  end

end
