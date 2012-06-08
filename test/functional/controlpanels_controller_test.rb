require 'test_helper'

class ControlPanelsControllerTest < ActionController::TestCase
  
  setup do    
    create_all_default_data    
    @employer =  create(:gustavo_de_antonio)
    @user = create(:pablo_rodriguez)
    @hugo = create(:hugo_rodriguez)
    @wo_1 = create(:wo_1,:car => @user.cars.first,:user => @employer,:company => @employer.company,:payment_method => create(:cash))
    @wo_2 = create(:wo_1,:car => @hugo.cars.first,:user => @employer,:company => @employer.company,:payment_method => create(:cash))
  end

  test "control panel index company" do
    sign_in @employer
    @request.cookies["company_id"]= @employer.company.id.to_s
    get :index
    assert_select("#company[value='#{@employer.company.id}']")
    assert_response :success
  end

  test "filter alarms" do
    sign_in @employer    
    #@request.env["devise.mapping"] = Devise.mappings[:users]   
    @request.cookies["company_id"]= @employer.company.id.to_s
    get :filter_alarms,:st => 1,:et =>"all"
    assert_response :success
    assert_template :filter_alarms
    assert_select("div#events div.cp_event",:count => 2)    
  end

  test "control panel index no user" do
    get :index    
    assert_response 302
    assert_redirected_to new_user_session_path
  end

  test "filter alarms company no user" do
    get :filter_alarms
    assert_response 302
    assert_redirected_to new_user_session_path
    
  end

end