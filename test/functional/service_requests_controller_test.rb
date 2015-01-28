require 'test_helper'

class ServiceRequestsControllerTest < ActionController::TestCase
  setup do
    create_all_default_data            
    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
    @pablo = create(:pablo_rodriguez)
  end

  test "should get index" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @employer    
    create(:sr)
    get :index
    assert_response :success
    assert_not_nil assigns(:service_requests)    
    assert_select("div",:class=>"service_request",:count=>1)
  end

  test "should get new" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @pablo
    get :new
    assert_response :success
  end

  test "should create service_request" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @pablo
    @service_request = build(:sr)
    assert_difference('ServiceRequest.count') do
      post :create, service_request: { vehicle_id: @service_request.vehicle_id, status: @service_request.status, user_id: @service_request.user_id }
    end

    assert_redirected_to service_request_path(assigns(:service_request))
  end

  test "should show service_request" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @pablo
    @service_request = create(:sr)
    get :show, id: @service_request
    assert_response :success
  end

  test "should get edit" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @pablo
    @service_request = create(:sr)
    get :edit, id: @service_request
    assert_response :success
  end

  test "should not get edit" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @service_request = create(:sr)
    sign_in @employer
    get :edit, id: @service_request
    assert_response :redirect
  end

  test "should update service_request" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @pablo
    @service_request = create(:sr)
    put :update, id: @service_request, service_request: { vehicle_id: @service_request.vehicle_id, company_id: @service_request.company_id, status: @service_request.status, user_id: @service_request.user_id }
    assert_redirected_to service_request_path(assigns(:service_request))
  end

  test "should not update service_request" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @service_request = create(:sr)
    sign_in @employer
    put :update, id: @service_request, service_request: { vehicle_id: @service_request.vehicle_id, company_id: @service_request.company_id, status: @service_request.status, user_id: @service_request.user_id }
    assert_redirected_to root_path
  end

  test "should destroy service_request" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @pablo
    @service_request = create(:sr)
    assert_difference('ServiceRequest.count', -1) do
      delete :destroy, id: @service_request
    end

    assert_redirected_to service_requests_path
  end
end
