require 'test_helper'

class BudgetsControllerTest < ActionController::TestCase

  setup do  
    create_all_default_data            
    @employer =  create(:gustavo_de_antonio)    
    @budget =  create(:budget_two,:creator => @employer,:company => @employer.company)
    @emp_walter =  create(:emp_walter,:employer => @employer.companies.first)
  end

  test "should get index" do
    @request.cookies["company_id"]= @emp_walter.company.id.to_s
    sign_in @employer
    get :index
    assert_response :success
    assert_not_nil assigns(:budgets)
    assert_select("div.budget_row",:count => 1)
    assert_select("a.edit",:count => 1)    
  end

  test "employe should get index" do
    @request.cookies["company_id"]= @emp_walter.company.id.to_s
    sign_in @emp_walter
    get :index
    assert_response :success
    assert_not_nil assigns(:budgets)
    assert_select("div",:class=>"budget_row")
    assert_select("a.edit",:count => 1)    
  end

  
  #test "should get new" do
  #  get :new
  #  assert_response :success
  #end

  #test "should create budget" do
  #  assert_difference('Budget.count') do
  #    post :create, :budget => @budget.attributes
  #  end
  #  assert_redirected_to budget_path(assigns(:budget))
  #end

  #test "should show budget" do
  #  get :show, :id => @budget.to_param
  #  assert_response :success
  #end

  #test "should get edit" do
  #  get :edit, :id => @budget.to_param
  #  assert_response :success
  #end

  #test "should update budget" do
  #  put :update, :id => @budget.to_param, :budget => @budget.attributes
  #  assert_redirected_to budget_path(assigns(:budget))
  #end

  #test "should destroy budget" do
  #  assert_difference('Budget.count', -1) do
  #    delete :destroy, :id => @budget.to_param
  #  end
  #  assert_redirected_to budgets_path
  #end

end
