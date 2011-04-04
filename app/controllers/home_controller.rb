class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def welcome
    if current_user
      @events = current_user.future_events(:per_page=>12)
    end
  end

  def index
    redirect_to :welcome
  end
end
