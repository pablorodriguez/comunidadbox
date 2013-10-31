require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  setup do
    Address.any_instance.stubs(:geocode).returns([1,1]) 
    create_all_default_data
    @pablo =  create(:pablo_rodriguez)
    @gustavo =  create(:gustavo_de_antonio)
    @marcelo =  create(:marcelo_de_antonio)
    @emp_walter =  create(:emp_walter)    
    @new_pablo =  create(:new_pablo_rodriguez)

    @imr_emp =  create(:imr_emp)
  end

  test "user is employee" do   
    assert @marcelo.is_employee?, "Marcelo de Antonio no es empleado"
    assert @gustavo.is_employee?, "Gustavo de Antonio no es empleado"
    assert @pablo.is_employee? == false, "Pablo Rodriguez no es empleado"
    assert @emp_walter.is_employee?, "Walter no es empleado"
  end

  test "employeer cant edit confirmed user" do   
    assert @gustavo.can_edit?(@pablo) == false
  end

  test "employeer can edit new client not confirmed" do
    @wo = create(:wo_oc,:car => @new_pablo.cars.first,:user => @gustavo,:company => @gustavo.company)    
    assert @gustavo.can_edit?(@new_pablo)
  end

  test "employeer cant edit other company client" do
    @wo = create(:wo_oc,:car => @new_pablo.cars.first,:user => @imr_emp,:company => @imr_emp.company)    
    assert @gustavo.can_edit?(@new_pablo) == false
  end

end