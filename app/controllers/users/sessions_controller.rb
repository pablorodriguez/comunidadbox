class Users::SessionsController < Devise::SessionsController  
  skip_before_filter :verify_authenticity_token
  
  include ApplicationHelper

  after_filter :set_company_id, :only =>[ :new, :create ]
  after_filter :clear_company_id, :only =>[:destroy]
 

end