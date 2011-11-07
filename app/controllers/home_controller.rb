class HomeController < ApplicationController
  layout "application"
  skip_before_filter :authenticate_user!
  
  def index
     if current_user
      @events = current_user.future_events(:per_page=>12)
    end
  end
end
