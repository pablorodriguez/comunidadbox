class HomeController < ApplicationController
  include ApplicationHelper
  layout "application"
  skip_before_filter :authenticate_user!,:only =>:index
  
  def index
    if current_user
      @events = current_user.future_events(:per_page=>12)
    end

    if current_user && current_user.disable
      flash[:notice] = 'No pude ingresar al sitio con un usuario deshabilitado'
      redirect_to destroy_user_session_path
    end
  end

  def set_company   
    logger.debug "### Companies IDS #{params[:company_ids]} ALL Comp #{params[:all_company]}"
    id=params[:company_ids]

    if id.nil?
      id = [current_user.company.id]
    end

    unless (params[:all_company])
      ids = params[:all_company] || []
      if (current_user.get_companies_ids.find_all{|e| ids.include?(e)} == ids)
        set_company_in_cookie id
      end
    else
        set_company_in_cookie ["-1"]
    end

    redirect_to :back
  end
end
