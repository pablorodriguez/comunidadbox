require 'test_helper'

class ControlPanelsControllerTest < ActionController::TestCase
  
  setup do    
    create_all_default_data
    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
    @user = create(:pablo_rodriguez)
    @hugo = create(:hugo_rodriguez)

    @final_status = @employer.company.get_final_status

    wo1 = create(:wo_oc,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company,:status_id => @final_status.id)
    wo2 = create(:wo_oc,:vehicle => @hugo.cars.first,:user => @employer,:company => @employer.company,:status_id => @final_status.id)

    wo3 = create(:wo_tc,:vehicle => @user.cars.first,:user => @employer,company: @employer.company,performed: Time.zone.now,:status_id => @final_status.id)
    wo4 = create(:wo_tc,:vehicle => @hugo.cars.first,:user => @employer,company: @employer.company,performed: Time.zone.now,:status_id => @final_status.id)

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
    st = ServiceType.where("company_id = ? and name =?",@employer.company.id,"Cambio de Aceite").first

    get :filter_alarms,:st => st.id,:et =>"all"
    assert_response :success
    assert_template :filter_alarms
    assert_select("div#events div.cp_event",:count => 2)    
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
    st = ServiceType.where("company_id = ? and name =?",@employer.company.id,"Cambio de Aceite").first

    get :filter_alarms,:st => st.id,:et =>"all"
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