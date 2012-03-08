require 'test_helper'

class WorkordersControllerTest < ActionController::TestCase
  
  test "should get index" do
  	sign_in users(:owner)
    get :index
    assert_response :success
    assert_template :index
    
    assert_select("div",:id=>"workorders",:count=>1)
    assert_select("div",:id=>"price_graph_c",:count=>1)
    assert_select("div",:id=>"report_data",:count=>1)

    assert_select("div",:id=>"vertical_menu",:count=>1)
    assert_select("div",:id=>"menu_options",:count=>1)
    assert_select("div",:class=>"menu_actions",:count=>1)


    
  end

end
