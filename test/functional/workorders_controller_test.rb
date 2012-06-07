require 'test_helper'

class WorkordersControllerTest < ActionController::TestCase
  
  setup do
    create :credit_card
    create :debit_card
    
    @user =  create(:pablo_rodriguez)
    @employer =  create(:gustavo_de_antonio)
    @wo_1 = create(:wo_1,:car => @user.cars.first,:user => @employer,:company => @employer.company,:payment_method => create(:cash))
  end

  test "list workorder" do
 	
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

    assert_select(".price_b",:text => "$60.00",:count=>1)
    
    #("div.services .service a").first().html()

    
    #assert_select("div",:id=>"menu_options",:count=>1)
    #assert_select("div",:class=>"menu_actions",:count=>1)
    
  end

  test "new work order company" do
    sign_in @employer
    @request.cookies["company_id"]= @employer.company.id.to_s

    car = @user.cars.first
    get :new, :car_id => car.to_param
    assert_response :success
    assert_select("#domain",:text => car.domain,:count=>1)
  end


  test "new work order other car" do
    sign_in create(:hugo_rodriguez)
    car = @user.cars.first
    get :new, :car_id => car.to_param
    response.code == "302"    
  end

  test "new work order own car" do
    user = create(:hugo_rodriguez)
    sign_in user
    car = user.cars.first
    get :new, :car_id => car.to_param,:company_id => @employer.company.id
    assert_response :success 
  end


  test "new work order own car on company" do
    user = create(:hugo_rodriguez)
    sign_in user
    car = user.cars.first
    get :new, :car_id => car.to_param,:c => "Empresa no registrada"
    assert_response :success 
  end

end
