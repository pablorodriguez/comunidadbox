  
require 'test_helper'

class NotesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do    
    create_all_default_data
    @user =  create(:pablo_rodriguez)

    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
  end

  test "should get index for employee" do
    @request.cookies["company_id"]= @employer.company.id.to_s  
    sign_in @employer
    get :index
    assert_response :success    
  end
 
  test "should get index for user" do    
    sign_in @user
    get :index
    assert_response :success    
  end
 
end