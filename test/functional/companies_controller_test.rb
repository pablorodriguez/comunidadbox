require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase
  
  setup do    
    create_all_default_data
    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
  end

  test "show all companies" do
    get :all
    assert_response :success
    assert_template :all
  end

end