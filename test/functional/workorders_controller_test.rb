require 'test_helper'

class WorkordersControllerTest < ActionController::TestCase
  
  setup do    
    @user =  create(:pablo_rodriguez)

    @employer =  create(:gustavo_de_antonio)
    
    @wo_1 = create(:wo_1,:car => @user.cars.first,:user => @employer)
    
  end

  test "list workorder valle grande neumaticos" do
 	
    sign_in @employer

    get :index
    assert_response :success
    assert_template :index
    
    assert_select("div",:id=>"workorders",:count=>1)
    assert_select("div#workorders .wo_detail",:count => 2)

    assert_select("div",:id=>"price_graph_c",:count=>1)
    assert_select("div",:id=>"report_data",:count=>1)
    assert_select("div",:id=>"company_id",:count=>1)

    assert_select("div#all_companies ul li",:count=>3)

    
    ("div.services .service a").first().html()

    assert_select("div",:id=>"vertical_menu",:count=>1)
    #assert_select("div",:id=>"menu_options",:count=>1)
    #assert_select("div",:class=>"menu_actions",:count=>1)
    
  end

end
