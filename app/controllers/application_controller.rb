# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ApplicationHelper
  helper :all # include all helpers, all the time
  before_filter :set_locale

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
  
  def set_locale
    I18n.locale = from_http || I18n.default_locale
  
    logger.debug "*locale'#{I18n.locale}"
    logger.debug "*locale default '#{I18n.default_locale}"
    logger.debug "*locale from'#{from_http}"


  end

 def set_locale
    I18n.locale = from_http || I18n.default_locale
    logger.debug "*locale'#{I18n.locale}"
    logger.debug "*locale default '#{I18n.default_locale}"
    logger.debug "*locale from'#{from_http}"
  end

  def from_http    
    if respond_to?(:request) && request.env && request.env['HTTP_ACCEPT_LANGUAGE']
      logger.debug "*requesttt'#{request.env['HTTP_ACCEPT_LANGUAGE'].split(",")[0]}'" 
      logger.debug " lenguajes del navegador--------- '#{pp request.env['HTTP_ACCEPT_LANGUAGE']}'" 
      return request.env['HTTP_ACCEPT_LANGUAGE'].split(",")[0]
      logger.debug "*requesttt'#{request.env['HTTP_ACCEPT_LANGUAGE'].split(",")[0]}'" 
     end
  end
end

