require 'test_helper'
		  
class CarServiceOffersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do    
    create_all_default_data    
    
    @pablo =  create(:pablo_rodriguez)
    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
    
    @imer_admin = create(:imr_admin)
  
  end

  test "car service offer list" do
    #sabado 1 de Diciembre del 2012
  	date_ini = Time.new(2012,12,1)
    date_end = date_ini + 1.month
    now = date_ini + 2.days

	  cso1 = create(:so_change_oil,:company => @employer.company,:since =>date_ini,:until=>date_end,:saturday => 1)
	  cso1.car_service_offers.create(:car=> @pablo.cars.first,:status => Status::CONFIRMED)

	  cso2 = create(:so_change_oil,:company => @imer_admin.company,:since =>date_ini,:until=>date_end,:saturday =>1,:friday => 1)
	  cso2.car_service_offers.create(:car=> @pablo.cars.first,:status => Status::CONFIRMED)

    @request.env["devise.mapping"] = Devise.mappings[:user]    
    sign_in @pablo
    
	  #Detengo el tiempo al sabado 1 de Diciembre del 2012
    Timecop.freeze(date_ini) do
	    get :index
	    assert_response :success
	    assert_template :index      
      assert_not_nil assigns(:car_service_offers)
    	assert_select("div.row",:count => 2)
	  
    end

  end

 	test "show car service from my company" do
    #sabado 1 de Diciembre del 2012
  	date_ini = Time.new(2012,12,1)
    date_end = date_ini + 1.month
    now = date_ini + 2.days

	  so = create(:so_change_oil,:company => @employer.company,:since =>date_ini,:until=>date_end,:saturday =>1,:friday => 1)
	  cso = so.car_service_offers.create(:car=> @pablo.cars.first,:status => Status::CONFIRMED)

    @request.env["devise.mapping"] = Devise.mappings[:user]    
    sign_in @employer
    
	  #Detengo el tiempo al sabado 1 de Diciembre del 2012
    Timecop.freeze(date_ini) do
    	#Muestro una oferta de servicio de auto de otra empresa
    	get :show, :id => cso.to_param
    	assert_response :success
	    assert_template :show
    end

  end

 	test "show car service car owner" do
    #sabado 1 de Diciembre del 2012
  	date_ini = Time.new(2012,12,1)
    date_end = date_ini + 1.month
    now = date_ini + 2.days

	  so = create(:so_change_oil,:company => @employer.company,:since =>date_ini,:until=>date_end,:saturday =>1,:friday => 1)
	  cso = so.car_service_offers.create(:car=> @pablo.cars.first,:status => Status::CONFIRMED)

    @request.env["devise.mapping"] = Devise.mappings[:user]    
    sign_in @pablo
    
	  #Detengo el tiempo al sabado 1 de Diciembre del 2012
    Timecop.freeze(date_ini) do
    	#Muestro una oferta de servicio de auto de otra empresa
    	get :show, :id => cso.to_param
    	assert_response :success
	    assert_template :show
    end

  end

  test "show other car service car owner" do
    #sabado 1 de Diciembre del 2012
  	date_ini = Time.new(2012,12,1)
    date_end = date_ini + 1.month
    now = date_ini + 2.days

	  so = create(:so_change_oil,:company => @imer_admin.company,:since =>date_ini,:until=>date_end,:saturday =>1,:friday => 1)
	  cso = so.car_service_offers.create(:car=> @pablo.cars.first,:status => Status::CONFIRMED)

    @request.env["devise.mapping"] = Devise.mappings[:user]    
    sign_in @pablo
    
	  #Detengo el tiempo al sabado 1 de Diciembre del 2012
    Timecop.freeze(date_ini) do
    	#Muestro una oferta de servicio de auto de otra empresa
    	get :show, :id => cso.to_param
    	assert_response :success
	    assert_template :show
    end

  end


  test "show car service from other company" do
    #sabado 1 de Diciembre del 2012
  	date_ini = Time.new(2012,12,1)
    date_end = date_ini + 1.month
    now = date_ini + 2.days

	  so = create(:so_change_oil,:company => @imer_admin.company,:since =>date_ini,:until=>date_end,:saturday =>1,:friday => 1)
	  cso = so.car_service_offers.create(:car=> @pablo.cars.first,:status => Status::CONFIRMED)

    @request.env["devise.mapping"] = Devise.mappings[:user]    
    sign_in @employer
    
	  #Detengo el tiempo al sabado 1 de Diciembre del 2012
    Timecop.freeze(date_ini) do
    	#Muestro una oferta de servicio de auto de otra empresa
    	get :show, :id => cso.to_param
    	#El sitio hace un redirect al root por que el usuario pertence a otra empresa
    	assert_redirected_to root_path 	    
    end

  end

end