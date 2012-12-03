require 'test_helper'

class ControlPanelsControllerTest < ActionController::TestCase
  
  setup do    
    create_all_default_data    
    @employer =  create(:gustavo_de_antonio)
    @user = create(:pablo_rodriguez)
    @hugo = create(:hugo_rodriguez)
    create(:wo_oc,:car => @user.cars.first,:user => @employer,:company => @employer.company)
    create(:wo_oc,:car => @hugo.cars.first,:user => @employer,:company => @employer.company)
    create(:wo_tc,:car => @user.cars.first,:user => @employer,company: @employer.company,performed: Time.zone.now)
    create(:wo_tc,:car => @hugo.cars.first,:user => @employer,company: @employer.company,performed: Time.zone.now)
  end

  test "control panel index company" do
    sign_in @employer
    @request.cookies["company_id"]= @employer.company.id.to_s
    get :index
    assert_select("#company[value='#{@employer.company.id}']")
    assert_response :success
  end

  test "filter alarms all events" do
    sign_in @employer        
    @request.cookies["company_id"]= @employer.company.id.to_s
    get :filter_alarms,:st => 1,:et =>"all"
    assert_response :success
    assert_template :filter_alarms
    assert_select("#events div.cp_event",:count => 2)    
  end

  #test "filter alarms green events" do
  #  sign_in @employer        
  #  @request.cookies["company_id"]= @employer.company.id.to_s
  #  get :filter_alarms,:st => 1,:green =>1
  #  assert_response :success
  #  assert_template :filter_alarms
  #  assert_select("div#events div.cp_event",:count => 2)    
  #end

  test "filter alarms red events" do
    sign_in @employer        
    @request.cookies["company_id"]= @employer.company.id.to_s
    get :filter_alarms,:st => 1,:et =>"all"
    assert_response :success
    assert_template :filter_alarms
    assert_select("div#events div.cp_event",:count => 2)
  end

  test "filter alarms yellow events" do
  end

  test "filter alarms by service type" do
  end

  #test "filter alarms by dates" do
  #  sign_in @employer        
  #  @request.cookies["company_id"]= @employer.company.id.to_s
  #  debugger
  #  get :filter_alarms,:st => 2,:service_filter =>{date_from: "01/02/2012",date_to: "29/02/2012"}
  #  assert_response :success
  #  assert_template :filter_alarms
  #  assert_select("div#events div.cp_event",:count => 1)    
  #end


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