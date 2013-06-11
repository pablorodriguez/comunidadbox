class EventsController < ApplicationController
  layout "application", :except => [:search_notes]

  def show
    @event = Event.find params[:id]
  end

  def search_notes
  	@event = Event.find params[:id]
  	@notes =  Note.for_event_end_user(@event,current_user)
    @alarms = Alarm.for_event_end_user(@event,current_user)
    
  	respond_to do |format|
      format.js {render :layout => false}
    end
  end
end
