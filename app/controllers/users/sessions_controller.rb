class Users::SessionsController < Devise::SessionsController  
  include ApplicationHelper

  after_filter :set_company_id,:only =>[ :new, :create ]


  def set_company_id
    if current_user      
      set_company_in_cookie current_user.company.id
    end
  end

end