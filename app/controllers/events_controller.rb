class EventsController < ApplicationController
  layout "application", :except => [:search_notes]

  def show
    @event = Event.find params[:id]
  end

  def search_notes
  	@event = Event.find params[:id]
  	@notes = @event.notes
    logger.debug "######## Event id for notes  #{@event.id}"
  	respond_to do |format|
      format.js {render :layout => false}
    end
  end
end
