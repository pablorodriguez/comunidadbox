require 'test_helper'

class WorkordersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do    
    create_all_default_data    
    @user =  create(:pablo_rodriguez)
    @employer =  create(:gustavo_de_antonio)
    @wo_1 = create(:wo_oc,:car => @user.cars.first,:user => @employer,:company => @employer.company)
  end

  test "list workorder" do
    setup_controller_for_warden
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.cookies["company_id"]= @employer.company.id.to_s

    sign_in @employer
    get :index
    assert_response :success
    assert_template :index
    
    assert_select("div",:id=>"workorders",:count=>1)
    assert_select("div#workorders .wo_detail",:count => 2)
    assert_select("div",:id=>"price_graph_c",:count=>1)
    assert_select("div",:id=>"report_data",:count=>1)
    assert_select("div",:id=>"company_id",:count=>1)
    assert_select("div",:id=>"vertical_menu",:count=>1)    
    assert_select("div#all_companies ul li",:count=>3)
    assert_select("#company[value='#{@employer.company.id}']")

    assert_select(".price_b",:text => "$60.00",:count=>1)
    
  end

  test "new work order form budget with car" do
    sign_in @employer    
    @request.cookies["company_id"]= @employer.company.id.to_s
    b = create(:budget_one,:car => @user.cars.first,:company => @employer.company,:creator =>@employer)
    car = @user.cars.first
    get :new, :b => b.id
    assert_response :success
    assert_select("#domain",:text => car.domain,:count=>1)
  end

  test "new work order form budget no car" do
    sign_in @employer    
    @request.cookies["company_id"]= @employer.company.id.to_s
    b = create(:budget_two,:company => @employer.company,:creator =>@employer)
    car = @user.cars.first
    get :new, :b => b.id    
    assert_redirected_to new_client_path(:b => b.id)    
  end


  test "new work order company" do
    sign_in @employer    
    @request.cookies["company_id"]= @employer.company.id.to_s

    car = @user.cars.first
    get :new, :car_id => car.to_param
    assert_response :success
    assert_select("#domain",:text => car.domain,:count=>1)
  end


  test "new work order no company other car" do
    sign_in create(:hugo_rodriguez)
    car = @user.cars.first
    get :new, :car_id => car.to_param    
    assert_response 302  
  end

  test "new work order no company own car" do
    user = create(:hugo_rodriguez)
    sign_in user
    car = user.cars.first
    get :new, :car_id => car.to_param
    assert_response 302 
  end


  test "new work order own car on company" do
    user = create(:hugo_rodriguez)
    sign_in user
    car = user.cars.first
    get :new, :car_id => car.to_param,:c => "Empresa no registrada"
    assert_response :success 
  end

end
