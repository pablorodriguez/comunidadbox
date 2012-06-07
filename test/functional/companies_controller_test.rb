require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase
  
  setup do    
  
  end

  test "show all companies" do
    get :all
    assert_response :success
    assert_template :all
  end

end