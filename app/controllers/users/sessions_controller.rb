class Users::SessionsController < Devise::SessionsController  
  include ApplicationHelper

  after_filter :set_company_id, :only =>[ :new, :create ]
  after_filter :clear_company_id, :only =>[:destroy]
 
  protected

  def set_company_id
    clear_company_id
    if current_user && current_user.company
      set_company_in_cookie(Array(current_user.company.id))
      logger.info "##### #{current_user.company.id}"
    end
    logger.info "##### sali de set_company_id"
    flash[:notice]=nil
  end

  def clear_company_id
  	cookies.delete(:company_id)
    flash[:notice]=nil
    logger.info "##### clear company id"
  end

end