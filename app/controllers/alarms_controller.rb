class AlarmsController < ApplicationController
  def index
    @alarms = current_user.alarms
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
    @alarm = current_user.alarms.new(params[:alarm])
    respond_to do |format|
      if @alarm.save
        flash[:notice] = 'La Alarma ha sido creada'
        format.html { redirect_to alarms_path }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @alarm = current_user.alarms.find(params[:id])
    if @alarm.update_attributes(params[:alarm])
      flash[:notice] = 'Alarma actualizada'
      redirect_to alarms_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @alarm = current_user.alarms.find(params[:id])
    @alarm.destroy
    redirect_to alarms_path
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

    flash[:notice] = 'Alarma Enviada'
    redirect_to list_alarm_now_alarms_path
  end
end

