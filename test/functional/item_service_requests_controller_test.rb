require 'test_helper'

class ItemServiceRequestsControllerTest < ActionController::TestCase
  setup do
    @item_service_request = item_service_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:item_service_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item_service_request" do
    assert_difference('ItemServiceRequest.count') do
      post :create, item_service_request: { date_from: @item_service_request.date_from, date_to: @item_service_request.date_to, description: @item_service_request.description, price: @item_service_request.price, service_request_id: @item_service_request.service_request_id, service_type_id: @item_service_request.service_type_id }
    end

    assert_redirected_to item_service_request_path(assigns(:item_service_request))
  end

  test "should show item_service_request" do
    get :show, id: @item_service_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @item_service_request
    assert_response :success
  end

  test "should update item_service_request" do
    put :update, id: @item_service_request, item_service_request: { date_from: @item_service_request.date_from, date_to: @item_service_request.date_to, description: @item_service_request.description, price: @item_service_request.price, service_request_id: @item_service_request.service_request_id, service_type_id: @item_service_request.service_type_id }
    assert_redirected_to item_service_request_path(assigns(:item_service_request))
  end

  test "should destroy item_service_request" do
    assert_difference('ItemServiceRequest.count', -1) do
      delete :destroy, id: @item_service_request
    end

    assert_redirected_to item_service_requests_path
  end
end
