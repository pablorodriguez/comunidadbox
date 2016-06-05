require 'test_helper'

class VehicleServiceOfferTest < ActiveSupport::TestCase
  setup do
    create_all_default_data    
    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
    @pablo =  create(:pablo_rodriguez)
    @imer_admin = create(:imr_admin)
    create_all_company_data @imer_admin.company_id
  end


  test "get vehicle service offer" do
  	date_ini = Time.new(2012,12,1)
    date_end = date_ini + 1.month

    now = date_ini + 2.days
	  service_offer = create(:so_change_oil,:company => @employer.company,:since =>date_ini,:until=>date_end)
	  service_offer.vehicle_service_offers.create(:vehicle=> @pablo.cars.first,:status => Status::CONFIRMED)
	  
    Timecop.freeze(date_ini + 1.day) do
	  	cso = @pablo.cars.first.search_service_offer @employer.company_id
	  	assert cso.size == 1
    end

  end

  test "get vehicle service offer different days 2" do
  	#sabado 1 de Diciembre del 2012
  	date_ini = Time.new(2012,12,1)
    date_end = date_ini + 1.month
    now = date_ini + 2.days

	  cso1 = create(:so_change_oil,:price =>333,:company => @employer.company,:since =>date_ini,:until=>date_end,:saturday => 1)
	  cso1.vehicle_service_offers.create(:vehicle=> @pablo.cars.first,:status => Status::CONFIRMED)

	  cso2 = create(:so_change_oil,:company => @employer.company,:since =>date_ini,:until=>date_end,:saturday =>1,:friday => 1)
	  cso2.vehicle_service_offers.create(:vehicle=> @pablo.cars.first,:status => Status::CONFIRMED)

		cso3 = create(:so_change_oil,:company => @employer.company,:since =>date_end + 1.day,:until=>date_end + 15.days)
	  cso3.vehicle_service_offers.create(:vehicle=> @pablo.cars.first,:status => Status::CONFIRMED)

	  #Detengo el tiempo al sabado 1 de Diciembre del 2012
    Timecop.freeze(date_ini) do
      cso = @pablo.cars.first.search_service_offer(@employer.company_id)
      assert cso.size == 2
    end
  
  end

  test "get vehicle service offer different days 1" do
    #sabado 1 de Diciembre del 2012
    date_ini = Time.new(2012,12,1)
    date_end = date_ini + 1.month
    now = date_ini + 2.days

    cso1 = create(:so_change_oil,:price =>333,:company => @employer.company,:since =>date_ini,:until=>date_end,:saturday => 1)
    cso1.vehicle_service_offers.create(:vehicle=> @pablo.cars.first,:status => Status::CONFIRMED)

    cso2 = create(:so_change_oil,:company => @employer.company,:since =>date_ini,:until=>date_end,:saturday =>1,:friday => 1)
    cso2.vehicle_service_offers.create(:vehicle=> @pablo.cars.first,:status => Status::CONFIRMED)

    cso3 = create(:so_change_oil,:company => @employer.company,:since =>date_end + 1.day,:until=>date_end + 15.days)
    cso3.vehicle_service_offers.create(:vehicle=> @pablo.cars.first,:status => Status::CONFIRMED)


    #Detengo el tiempo al sabado 1 de Diciembre del 2012
    Timecop.freeze(date_end +2.days) do
      cso = @pablo.cars.first.search_service_offer(@employer.company_id)
      assert cso.size == 1
    end

  end

	test "get vehicle service offer different companies" do
  	#sabado 1 de Diciembre del 2012
  	date_ini = Time.new(2012,12,1)
    date_end = date_ini + 1.month
    now = date_ini + 2.days

	  cso1 = create(:so_change_oil,:company => @employer.company,:since =>date_ini,:until=>date_end,:saturday => 1)
	  cso1.vehicle_service_offers.create(:vehicle=> @pablo.cars.first,:status => Status::CONFIRMED)

	  cso2 = create(:so_change_oil,:company => @imer_admin.company,:since =>date_ini,:until=>date_end,:saturday =>1,:friday => 1)
	  cso2.vehicle_service_offers.create(:vehicle=> @pablo.cars.first,:status => Status::CONFIRMED)

	  #Detengo el tiempo al sabado 1 de Diciembre del 2012
    Timecop.freeze(date_ini) do
	  	cso = @pablo.cars.first.search_service_offer(@employer.company_id)	  	
	  	assert cso.size == 1
    end

    Timecop.freeze(date_ini) do
	  	cso = @pablo.cars.first.search_service_offer(@imer_admin.company_id)	  	
	  	assert cso.size == 1
    end

  end

	test "get vehicle service offer different status" do
  	#sabado 1 de Diciembre del 2012
  	date_ini = Time.new(2012,12,1)
    date_end = date_ini + 1.month
    now = date_ini + 2.days

	  cso1 = create(:so_change_oil,:company => @employer.company,:since =>date_ini,:until=>date_end,:saturday => 1)
	  cso1.vehicle_service_offers.create(:vehicle=> @pablo.cars.first,:status => Status::CONFIRMED)

	  cso2 = create(:so_change_oil,:company => @employer.company,:since =>date_ini,:until=>date_end,:saturday =>1,:friday => 1)
	  cso2.vehicle_service_offers.create(:vehicle=> @pablo.cars.first,:status => Status::SENT)

	  #Detengo el tiempo al sabado 1 de Diciembre del 2012
    Timecop.freeze(date_ini) do
	  	cso = @pablo.cars.first.search_service_offer(@employer.company_id)	  	
	  	assert cso.size == 1
    end

  end

  test "do not list vehicle service offer that belong to a workorder" do
  	#sabado 1 de Diciembre del 2012
  	date_ini = Time.new(2012,12,1)
    date_end = date_ini + 1.month
    now = date_ini + 2.days
    so = create(:so_change_oil,:company => @employer.company,:since =>date_ini,:until=>date_end,:saturday => 1)
	  cso = so.vehicle_service_offers.create(:vehicle=> @pablo.cars.first,:status => Status::CONFIRMED)

	  so = create(:so_change_oil,:company => @employer.company,:since =>date_ini,:until=>date_end,:saturday =>1,:friday => 1)
	  so.vehicle_service_offers.create(:vehicle=> @pablo.cars.first,:status => Status::CONFIRMED)

	  #Agrego la oferta de servcio al servicio
		wo = build(:wo_oc,:vehicle => @pablo.cars.first,:user => @employer,:company => @employer.company)
		wo.services.first.vehicle_service_offer = cso
		wo.services.first.status =  @employer.company.get_final_status		
		wo.save
	  
	  #Detengo el tiempo al sabado 1 de Diciembre del 2012
    Timecop.freeze(date_ini) do
	  	cso = @pablo.cars.first.search_service_offer(@employer.company_id)	  		  	
	  	assert cso.size == 1
    end
  end
 end
