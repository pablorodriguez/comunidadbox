require 'test_helper'

class NoTableModelTest < ActiveSupport::TestCase
  
  
  test "clear model attributes" do
    model = EmployeeSearch.new

    model.first_name = "test"

    assert_equal model.first_name, "test"
    assert model.first_name?
    
    model.clear_first_name

    assert_nil model.clear_first_name
  end

end