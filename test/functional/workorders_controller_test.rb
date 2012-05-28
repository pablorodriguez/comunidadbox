require 'test_helper'

class WorkordersControllerTest < ActionController::TestCase
  
  setup do    
    #Creo el usuario dueño de un service center
    @user =  FactoryGirl.create(:gustavo_de_antonio)

    #Creo el material mano de obra
    @hand_work_material = FactoryGirl.create(:hand_work_material)

    #Creo el material para el tipo de servicio tire_change
    @hand_work_tire_change = FactoryGirl.create(:hand_work_for_tire_change,:material => @hand_work_material)

    #Creo el material para el tipo de servicio oil change
    @hand_work_oil_change = FactoryGirl.create(:hand_work_oil_change,:material => @hand_work_material)

    #Creo el material del servicio
    @m_s = FactoryGirl.build(:material_service,:material_service_type => @hand_work_oil_change)

    #Creo el servicio 
    @service = FactoryGirl.build(:service,:material_services => @m_s)

    #Creo la WO con el servicio
    @service = FacotryGirl.create(:wo_1,:service => @service)
    
  end

  test "list workorder valle grande neumaticos" do
 	
    sign_in @user

    get :index
    assert_response :success
    assert_template :index
    
    assert_select("div",:id=>"workorders",:count=>1)
    assert_select("div#workorders .wo_detail",:count => 2)

    assert_select("div",:id=>"price_graph_c",:count=>1)
    assert_select("div",:id=>"report_data",:count=>1)
    assert_select("div",:id=>"company_id",:count=>1)

    assert_select("div#all_companies li",:count=>3)    

    assert_select("div",:id=>"vertical_menu",:count=>1)
    #assert_select("div",:id=>"menu_options",:count=>1)
    #assert_select("div",:class=>"menu_actions",:count=>1)
    
  end

end
