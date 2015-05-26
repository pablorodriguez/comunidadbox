require 'test_helper'

class BudgetTest < ActiveSupport::TestCase

  setup do
    create_all_default_data    
    @pablo =  create(:pablo_rodriguez)
    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
    @emp_walter =  create(:emp_walter)  
  end

  test "bidget cant send message" do
    budget =  create(:budget_two,:creator => @employer,:company => @employer.company)
    assert budget.can_send_message?(@employer) == false
  end

  test "bidget can send message" do
    budget =  create(:budget_hrj549,:creator => @employer,:company => @employer.company,:user =>@pablo, :vehicle => @pablo.cars.first)
    assert budget.can_send_message?(@employer)
  end

end