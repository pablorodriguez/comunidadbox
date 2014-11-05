require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  
  setup do  
    create_all_default_data            
    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
  end


  test "should create a client" do
  car = build("HRJ549")
  @request.cookies["company_id"]= @employer.company.id.to_s
  sign_in @employer
  assert_difference('User.count',1,"no hay nuevos clientes") do
    post :create, :user => {
      :first_name => "Pablo",
      :last_name => "Rodriguez",
      :phone => "4526157",
      :email => "pablo@rodriguez.com",
      
      :car_attributes => [
        {
          :domain => car.domain,
          :brand_id => car.brand_id,
          :model_id => car.model_id,
          :kmAverageMonthly => car.kmAverageMonthly,
          :km => car.km,
          :year => car.year
        }
      ],
      :address_attributes => {
        :city =>"Godoy Cruz",
        :street => "Portugal 1324",
        :zip => "5501",
        :state_id => State.find(1).id
      }
    }
  end
  assert_redirected_to clients_path
  end
end