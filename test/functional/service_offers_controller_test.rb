require 'test_helper'

class ServiceOffersControllerTest < ActionController::TestCase
  setup do
    create_all_default_data            
    @employer =  create(:gustavo_de_antonio)     
    @pablo = create(:pablo_rodriguez)
    @user = create(:imr_admin)
    @so = create(:so_ad_1_day,:company => @employer.company)
    @so1 = create(:so_ad_1_day,:company => @employer.company, :cars => @pablo.cars)
    @so2 = create(:so_ad_2_day,:company => @employer.company)
  end

  test "should get index" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.cookies["company_id"]= @employer.company.id.to_s

    sign_in @employer    
    get :index
    
    assert_response :success
    assert_select("div.service_offer_row",:count=>3)
    assert_select("a.view",:text => @so.title,:count=>3)
  end

  test "car user should get empty index" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  
    sign_in @pablo
    get :index
    
    assert_response :success
    assert_select "div.service_offer_row",false
  end

  test "do not show other company service offer" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.cookies["company_id"]= @user.company.id.to_s

    sign_in @pablo
    get :index
    assert_response :success
    assert_select ".service_offer_row",false

  end


end
