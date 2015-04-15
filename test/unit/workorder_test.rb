require 'test_helper'

class WorkorderTest < ActiveSupport::TestCase
  # Replace this with your real tests.

  setup do
    create_all_default_data    
    @user =  create(:pablo_rodriguez)
    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
    
    @emp_walter =  create(:emp_walter)
    
  end

  test "event in 2 months" do
    car = @user.cars.first
    performed = Time.zone.now.to_date
    @wo = create(:wo_oc,:vehicle => car,:user => @employer,:company => @employer.company,:performed => performed,:status_id => 2)
    event = @wo.services.first.events.first    
    assert event.dueDate == performed + 2.months,"Event no esta a los 2 meses"
    car.kmAverageMonthly = 2000
    car.save
    
    @wo.reload
    event = @wo.services.first.events.first
    assert event.dueDate == performed + 5.months ,"Error en dueDate despues de actualizar kilometraje al auto"

  end

  test "validate dueDate of events generated" do
    @wo = create(:wo_oc,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company,:status_id => 2)
    
    event = @wo.services.first.events.first
    new_due_date = @wo.performed + 2.months
    assert(new_due_date == event.dueDate, "New Date: #{new_due_date} <> Event: #{event.dueDate} --- WO: #{@wo.performed} Vehicle Km Avg: #{@wo.vehicle.kmAverageMonthly} ST: #{event.service.service_type.kms}")

  end

  test "user cant delete company workorder close" do
    @wo = create(:wo_oc,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company)
    assert @wo.can_delete?(@user) == false
  end

  test "user cant delete company workorder open" do
    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company)
    assert @wo.can_delete?(@user) == false
  end

  test "user can delete his workorder close" do
    @wo = create(:wo_oc,:vehicle => @user.cars.first,:user => @user,:company => @employer.company)
    assert @wo.can_delete?(@user) 
  end

  test "user can delete his workorder open" do
    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @user,:company => @employer.company)
    assert @wo.can_delete?(@user) 
  end

  test "user can edit his workorder open" do
    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @user,:company => @employer.company)
    assert @wo.can_edit?(@user)
  end

  test "user can edit his workorder close" do
    @wo = create(:wo_oc,:vehicle => @user.cars.first,:user => @user,:company => @employer.company)
    assert @wo.can_edit?(@user)
  end

  test "user cant edit company workorder open" do
    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company)    
    assert @wo.can_edit?(@user) == false
  end

  test "employer cant delete his workorder close" do
    @wo = create(:wo_oc,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company,:status_id => 2)
    assert @wo.can_delete?(@employer) == false
  end

  test "employer cant edit his workorder close" do
    @wo = create(:wo_oc,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company,:status_id => 2)
    assert @wo.can_edit?(@employer) == false
  end

  test "employer can edit his workorder open" do
    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company)
    assert @wo.can_edit?(@employer)
  end

  test "employer cant edit user workorder open" do
    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @user,:company => @employer.company)
    assert @wo.can_edit?(@employer) == false
  end

  test "employer cant edit user workorder close" do
    @wo = create(:wo_oc,:vehicle => @user.cars.first,:user => @user,:company => @employer.company)
    assert @wo.can_edit?(@employer) == false
  end  

  test "employer can delete workorder open" do
    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company)
    assert @wo.can_delete?(@employer)
  end
  
end
