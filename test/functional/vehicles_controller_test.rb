require 'test_helper'

class VehiclesControllerTest < ActionController::TestCase
  
  setup do    
    create_all_default_data
    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
    
    @user = create(:pablo_rodriguez)
    @hugo = create(:hugo_rodriguez)
    @car = @user.cars.first
  end

  test "show client car" do
  
    sign_in @employer
    
    get :show, :id => @car.to_param
    assert_response :success
    assert_template :show
    
    #assert_select("div",:id=>"workorders",:count=>1)
    #assert_select("div#workorders .wo_detail",:count => 2)
    #assert_select("div",:id=>"price_graph_c",:count=>1)
    #assert_select("div",:id=>"report_data",:count=>1)
    #assert_select("div",:id=>"company_id",:count=>1)
    #assert_select("div",:id=>"vertical_menu",:count=>1)
    #assert_select("div#all_companies ul li",:count=>3)

    #assert_select(".price_b",:text => "$60.00",:count=>1)
    
    #("div.services .service a").first().html()

    
    #assert_select("div",:id=>"menu_options",:count=>1)
    #assert_select("div",:class=>"menu_actions",:count=>1)
    
  end

  test "show all my car" do
    sign_in @hugo
    get :index
    assert_response :success
    assert_template :index
        
  end

  test "show other car" do
    sign_in @hugo
      
    get :show, :id => @car.to_param
    response.code == "302"
    assert_redirected_to root_path    
  end


end