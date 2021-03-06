require 'test_helper'

class WorkordersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do    
    create_all_default_data    
    
    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
    @user =  create(:pablo_rodriguez)

    @hugo = create(:hugo_rodriguez)
    @wo_1 = create(:wo_oc,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company,:status_id => 2)
    @wo_open = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company,:status_id => 1)
    @wo_2 = create(:wo_oc,:vehicle => @hugo.cars.first,:user => @employer,:company => @employer.company,:status_id => 2)

    @st_oil_change = ServiceType.where("name like ? and company_id = ? ","Cambio de Aceite",@employer.company.id).first
    @cash = PaymentMethod.where("name like ?","Efectivo").first
  end

  test "cant print other workorder company" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @employer

    #Creo una orden de trabajo para otra empresa
    @imr_admin =  create(:imr_admin)
    create_all_company_data @imr_admin.company_id
    
    @wo_imr = create(:wo_tc,:vehicle => @user.cars.first,:user => @imr_admin,:company => @imr_admin.company,:status_id => 1)

    get :show,:id => @wo_imr.to_param, :format => "pdf"
    assert_redirected_to root_path
    
  end

  test "can print workorder company" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @employer

    get :print,:id => @wo_1.to_param, :format => "pdf"
    assert_response :success
    
  end

  test "employee cant print workorder" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @employer

    get :show,:id => @wo_1.to_param, :format => "pdf"
    assert_redirected_to root_path

  end
  
  test "user can print workorder" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @user

    get :show,:id => @wo_1.to_param, :format => "pdf"
    assert_response :success

  end

  test "employer list workorder" do
    
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.cookies["company_id"]= @employer.company.id.to_s
    sign_in @employer
    
    get :index
    assert_response :success
    assert_template :index

    assert_select("div",:id=>"workorders",:count=>1)
    assert_select("div#workorders .row",:count => 3)
    assert_select("div",:id=>"price_graph_c",:count=>1)
    assert_select("div",:id=>"report_data",:count=>1)
    assert_select("div",:id=>"company_id",:count=>1)
    assert_select("div",:id=>"vertical_menu",:count=>1)    
    assert_select("div#all_companies ul li",:count=>3)
    assert_select("#company[value='#{@employer.company.id}']")

    assert_select(".price_b",:text => "$60,00",:count=>3)

    assert_select("div#report_amount")
    assert_select("div#report_quantity")
    assert_select("div#report_material")
    assert_select("div#report_detail")
  end


  test "user list workorder" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @user
    
    get :index
    assert_response :success
    assert_template :index
    assert_select("div",:id=>"workorders",:count=>1)
    assert_select(".price_b",:text => "$60,00",:count=>2)
    assert_select("div#report_amount",:count =>0)
    assert_select("div#report_quantity",:count =>0)
    assert_select("div#report_material",:count =>0)
    assert_select("div#report_detail",:count =>0)
  end


  test "user do not list other workorder" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @user
    get :index
    assert_response :success
    assert_template :index

    assert_select(".row",2)
    
    assert_select(".price_b",:text => "$60,00",:count=>2)
    assert_select("div#report_amount",0)
    assert_select("div#report_quantity",0)
    assert_select("div#report_material",0)
    assert_select("div#report_detail",0)
  end


  test "new work order form budget with vehicle" do
    sign_in @employer    
    @request.cookies["company_id"]= @employer.company.id.to_s
    b = create(:budget_one,:vehicle => @user.cars.first,:company => @employer.company,:creator =>@employer)
    car = @user.cars.first
    get :new, :b => b.id
    assert_response :success
    assert_select(".domain",:text => car.domain,:count=>1)
  end

  test "new work order form budget no vehicle" do
    sign_in @employer    
    @request.cookies["company_id"]= @employer.company.id.to_s
    b = create(:budget_two,:company => @employer.company,:creator =>@employer)
    car = @user.cars.first
    get :new, :b => b.id    
    assert_redirected_to new_client_path(:b => b.id)    
  end

  test "edit work order company" do
    sign_in @employer    
    @request.cookies["company_id"]= @employer.company.id.to_s
    get :edit ,:id => @wo_1.to_param
    assert_response :success
    assert_select("#total_work_order",/60.00/)
  end

  test "edit other work order company" do
    wo = create(:wo_oc,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company,:status_id => 1)
    sign_in @user        
    get :edit ,:id => wo.to_param
    assert_redirected_to root_path    
  end
  
  test "delete work order company" do
    sign_in @employer    
    @request.cookies["company_id"]= @employer.company.id.to_s
    xhr :delete,:destroy,:id => @wo_1.to_param
    assert_response :success    
  end

  test "delete work order other company" do
    imr_admin =  create(:imr_admin)
    sign_in imr_admin
    @request.cookies["company_id"]= imr_admin.company.id.to_s
    xhr :delete,:destroy,:id => @wo_1.to_param
    assert_redirected_to root_path     
  end

  test "new work order company" do
    sign_in @employer    
    @request.cookies["company_id"]= @employer.company.id.to_s

    car = @user.cars.first
    get :new, :vehicle_id => car.to_param
    assert_response :success
    assert_select(".domain",:text => car.domain,:count=>1)
  end

   test "show work order company" do
    sign_in @employer    
    @request.cookies["company_id"]= @employer.company.id.to_s  
    get :show, :id => @wo_1.to_param
    assert_response :success    
  end


  test "new work order no company other vehicle" do
    sign_in @hugo
    car = @user.cars.first
    get :new, :vehicle_id => car.to_param    
    assert_response 302  
  end

  test "new work order no company own vehicle" do
    user = @hugo
    sign_in user
    car = user.cars.first
    get :new, :vehicle_id => car.to_param
    assert_response 302 
  end


  test "new work order own vehicle on company" do
    user = @hugo
    sign_in user
    car = user.cars.first
    get :new, :vehicle_id => car.to_param,:c => "Empresa no registrada"
    assert_response :success 
  end

  test "create new work order company" do
    sign_in @employer    
    @request.cookies["company_id"]= @employer.company.id.to_s  
    client = @hugo
    assert_difference('Workorder.count',1,"no hay unan nueva workorder") do
      post :create, :workorder => {
        :performerd => Time.now.strftime("%d/%m/%Y"),
        :deliver => 1.hour.since.strftime("%d/%m/%Y %H:%m"),
        :vehicle_id =>client.cars.first.to_param,
        :company_id=>@employer.company.to_param,
        :payment_method_id => @cash.id ,
        :services_attributes => [
          {
            :status_id => 1,
            :service_type_id => @st_oil_change.id,
            :material_services_attributes =>[
              {
              :material => "FILTRO DE ACEIT",
              :amount =>"1",
              :price => "250",
              :_destroy => "false"
              }
            ]          
          }
        ]
      }
    end
    assert_redirected_to assigns(:work_order)
  end

  test "create new work order company no performed" do
    sign_in @employer    
    @request.cookies["company_id"]= @employer.company.id.to_s  
    client = @hugo
   


    assert_difference('Workorder.count',1,"no hay unan nueva workorder") do
      post :create, :workorder => {
        :deliver => 1.hour.since.strftime("%d/%m/%Y %H:%m"),
        :vehicle_id =>client.cars.first.to_param,
        :company_id=>@employer.company.to_param,
        :payment_method_id => @cash.id,
        :services_attributes => [
          {
            :status_id => 1,
            :service_type_id => @st_oil_change.id,
            :material_services_attributes =>[
              {
              :material => "FILTRO DE AIRE",
              :amount =>"2",
              :price => "250",
              :_destroy => "false"
              }
            ]          
          }
        ]
      }
    end
    assert_not_nil assigns(:work_order)
    assert_redirected_to assigns(:work_order)    
  end

end
