class HomeController < ApplicationController
  include ApplicationHelper
  layout "application"
  skip_before_filter :authenticate_user!,:only =>:index
  
  def index
    if current_user
      @events = current_user.future_events(:per_page=>12)
    end
  end

  def set_company   
    logger.debug params.to_s
    id=params[:company][:id]
    if id=="-1" || current_user.companies.find(id)
      set_company_in_cookie id
    end
    redirect_to :back
  end
end
