require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  setup do
    create_all_default_data
    @pablo =  create(:pablo_rodriguez)
    @gustavo =  create(:gustavo_de_antonio)
    @marcelo =  create(:marcelo_de_antonio)
    @emp_walter =  create(:emp_walter)    
  end

  test "user is employee" do   
    assert @marcelo.is_employee?, "Marcelo de Antonio no es empleado"
    assert @gustavo.is_employee?, "Gustavo de Antonio no es empleado"
    assert @pablo.is_employee? == false, "Pablo Rodriguez no es empleado"
    assert @emp_walter.is_employee?, "Walter no es empleado"
  end


end