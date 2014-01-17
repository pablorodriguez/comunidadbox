class Users::ConfirmationsController < Devise::ConfirmationsController  
  skip_before_filter :verify_authenticity_token
  
  include ApplicationHelper

  after_filter :set_company_id, :only =>[ :show ]
  
 
end