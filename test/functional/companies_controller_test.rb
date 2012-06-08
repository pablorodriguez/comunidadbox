require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase
  
  setup do    
    create_all_default_data
    @employer =  create(:gustavo_de_antonio)
  end

  test "show all companies" do
    get :all
    assert_response :success
    assert_template :all
  end

end