class AlarmsController < ApplicationController
  def index
    @alarms = current_user.alarms.order("next_time desc")
  end

  def show
    @alarm = Alarm.find(params[:id])
  end

  def new
    @alarm = current_user.alarms.new
  end

  def edit
    @alarm = current_user.alarms.find(params[:id])
  end

  def create    
    if params[:event_id]
      event = Event.find(params[:event_id])
      @alarm = event.alarms.build(params[:alarm])
      @alarm.user = current_user
    else
      @alarm = current_user.alarms.new(params[:alarm])      
    end
    
    
    respond_to do |format|
      if @alarm.save        
        format.html { redirect_to alarms_path }
        format.js {render :file=>"alarms/new_alarm.js.erb",:layout => false}
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @alarm = current_user.alarms.find(params[:id])
    
    if @alarm.update_attributes(params[:alarm])      
      redirect_to alarms_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @alarm = current_user.alarms.find(params[:id])
    @alarm.destroy    
    respond_to do |format|
      format.html { redirect_to(alarms_path) }
      format.js {render :layout => false}
      format.xml  { head :ok }
    end
  end

  def list_alarm_now
    @alarms = Alarm.find(:all, :conditions => 
      ['status = ? AND date_ini <= ? AND date_end >= ? AND date_alarm >= ? AND date_alarm <= ?' , 'Activado', 
      Time.zone.now, Time.zone.now, 
      120.seconds.until(Time.zone.now), 
      120.seconds.since(Time.zone.now)])
    @alarms = Alarm.find(:all)
  end

  def send_alarm
    AlarmMailer.deliver_alarm(User.find(params[:user]), Alarm.find(params[:alarm]))

    alarm = Alarm.find(params[:alarm])
    unless alarm.time == 0
      case alarm.time_unit
        when 'Anos'
          alarm.date_alarm = alarm.time.years.since(alarm.date_alarm)
        when 'Meses'
          alarm.date_alarm = alarm.time.months.since(alarm.date_alarm)
        when 'Dias'
          alarm.date_alarm = alarm.time.days.since(alarm.date_alarm)
        when 'Hs'
          alarm.date_alarm = alarm.time.hours.since(alarm.date_alarm)
      end
      alarm.save!
    end
    
    redirect_to list_alarm_now_alarms_path
  end
end

