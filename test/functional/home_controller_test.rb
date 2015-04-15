require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do    
    create_all_default_data    
    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
    @marcelo =  create(:marcelo_de_antonio)
  
  end

  test "employer login" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @employer
    get :index
    assert_response :success
  end

  test "employee admin login" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @marcelo
    get :index
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end


end