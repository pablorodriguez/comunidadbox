# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ApplicationHelper
  helper :all # include all helpers, all the time
  LANGUAGES = {'en' => 'en-US','en-US' => 'en-US','es' => 'es-AR','es-AR' =>'es-AR'}    
  
  require 'csv'

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => 'eee70de2e239c7e16b4f9229f56b8209'

  # If you want "remember me" functionality, add this before_filter to Application Controller
  #  before_filter :login_from_cookie,:login_required, :except =>[:welcome,:login,:signup]

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password
  before_filter :authenticate_user!
  

  rescue_from CanCan::AccessDenied do |exception|    
    redirect_to root_url, :alert => exception.message
  end

  before_filter :set_i18n_locale_from_params

  protected
  def set_i18n_locale_from_params
    if params[:locale]
      if LANGUAGES[params[:locale]]
        I18n.locale = LANGUAGES[params[:locale]]
      else
        flash.now[:notice] = "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    end  
  end

  def default_url_options
    { :locale => I18n.locale }
  end

end

