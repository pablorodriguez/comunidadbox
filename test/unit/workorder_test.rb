require 'test_helper'

class WorkorderTest < ActiveSupport::TestCase
  # Replace this with your real tests.

  setup do
    create_all_default_data    
    @user =  create(:pablo_rodriguez)
    @employer =  create(:gustavo_de_antonio)
    
  end

  test "validate dueDate of events generated" do
    @wo = create(:wo_oc,:car => @user.cars.first,:user => @employer,:company => @employer.company)
    
    event = @wo.services.first.events.first
    new_due_date = @wo.performed + 2.months
    assert(new_due_date == event.dueDate, "New Date: #{new_due_date} <> Event: #{event.dueDate} --- WO: #{@wo.performed} Car Km Avg: #{@wo.car.kmAverageMonthly} ST: #{event.service.service_type.kms}")

  end
end
