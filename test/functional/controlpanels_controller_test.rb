require 'test_helper'

class ControlPanelsControllerTest < ActionController::TestCase
  
  setup do
    create :credit_card
    create :debit_card
    
    @user =  create(:pablo_rodriguez)
    @employer =  create(:gustavo_de_antonio)
    @wo_1 = create(:wo_1,:car => @user.cars.first,:user => @employer,:company => @employer.company,:payment_method => create(:cash))
  end

  test "control panel index company" do
    sign_in @employer
    @request.cookies["company_id"]= @employer.company.id.to_s
    get :index
    assert_response :success
  end

  test "filter alarms" do
    sign_in @employer
    @request.cookies["company_id"]= @employer.company.id.to_s
    get :filter_alarms,:st => 1,:et =>"all"
    assert_response :success
    assert_template :filter_alarms
    assert_select(".cp_event",:count => 1)    
  end

  test "control panle index no user" do
    get :index    
    response.code == "302"
    assert_redirected_to new_user_session_path
  end

  test "filter alarms company no user" do
    get :filter_alarms
    response.code == "302"
    assert_redirected_to new_user_session_path
    
  end

end