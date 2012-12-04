require 'test_helper'

class BudgetsControllerTest < ActionController::TestCase

  setup do  
    create_all_default_data            
    @employer =  create(:gustavo_de_antonio)    
    @emp_walter =  create(:emp_walter,:employer => @employer.companies.first)
  end

  test "should get index" do
    @request.cookies["company_id"]= @employer.company.id.to_s
    @budget =  create(:budget_two,:creator => @employer,:company => @employer.company)
    sign_in @employer
    get :index
    assert_response :success
    assert_not_nil assigns(:budgets)
    assert_select("div.budget_row",:count => 1)
    assert_select("a.edit",:count => 1)    
  end

  test "employe should get index" do
    @budget =  create(:budget_two,:creator => @employer,:company => @employer.company)
    @request.cookies["company_id"]= @employer.company.id.to_s
    sign_in @emp_walter
    get :index
    assert_response :success
    assert_not_nil assigns(:budgets)
    assert_select("div",:class=>"budget_row")
    assert_select("a.edit",:count => 1)    
  end

  
  test "should get new" do
    sign_in @employer
    get :new
    assert_response :success
    assert_select("input#budget_first_name")
  end

  test "should create budget" do
    budget =  build(:budget_two,:creator => @employer,:company => @employer.company)
    @request.cookies["company_id"]= @employer.company.id.to_s
    sign_in @employer
    assert_difference('Budget.count',1,"no hay nuevos presupuestos") do
      post :create, :budget => {
        :first_name => budget.first_name,
        :last_name => budget.last_name,
        :phone => budget.phone,
        :model => budget.model,
        :brand => budget.brand,
        :services_attributes => [
          {
            :service_type_id => 2,
            :material_services_attributes => [{
              :materila => "mano de obra",
              :amount => 2,
              :price => 200
            }]
          }
        ]
      }
    end
    assert_redirected_to budget_path(assigns(:budget))
  end

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
