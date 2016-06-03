require 'test_helper'

class WorkorderTest < ActiveSupport::TestCase
  # Replace this with your real tests.

  setup do
    create_all_default_data
    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
    @user =  create(:pablo_rodriguez)

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

  test "validate number generation for valid work order" do
    last_work_order_number = CompanyAttribute.get_last_work_order_number @employer.company_id
    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company)
    assert @wo.nro == 1
    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company)
    assert @wo.nro == 2
  end

  test "validate number generation for invalid work order" do
    begin
      create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company)
      create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company)
      last_work_order_number = CompanyAttribute.get_last_work_order_number @employer.company_id
      assert last_work_order_number == 2

      @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:company => @employer.company)
    rescue ActiveRecord::RecordInvalid
      last_work_order_number = CompanyAttribute.get_last_work_order_number @employer.company_id
      assert last_work_order_number == 2
    end
  end

  test "validate number generation for branch company" do
    employee_peru = create(:emp_vg_peru)
    last_work_order_number = CompanyAttribute.get_last_work_order_number @employer.company_id
    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company)
    assert @wo.nro == 1

    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company)
    assert @wo.nro == 2

    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => employee_peru.company)
    assert @wo.nro == 3

    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => employee_peru.company)
    assert @wo.nro == 4

    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company)
    assert @wo.nro == 5

    vg_peru_attr = CompanyAttribute.create({company_id: employee_peru.company.id})

    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => employee_peru.company)
    assert @wo.nro == 5

    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => employee_peru.company)
    assert @wo.nro == 6

    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company)
    assert @wo.nro == 6

    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => employee_peru.company)
    assert @wo.nro == 7

    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => @employer.company)
    assert @wo.nro == 7

    @wo = create(:wo_oc_open,:vehicle => @user.cars.first,:user => @employer,:company => employee_peru.company)
    assert @wo.nro == 8

  end

end
