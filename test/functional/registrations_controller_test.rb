require 'test_helper'

class Users::RegistrationsControllerTest < ActionController::TestCase
  
  setup do  
    create_all_default_data            
    @employer =  create(:gustavo_de_antonio)      
  end


  test "should register a user" do
    @request.env["devise.mapping"] = Devise.mappings[:user]

    car = build("HRJ549")
    
    assert_difference('User.count',1,"no hay nuevos usuarios") do
      post :create, :user => {
        :first_name => "Pablo",
        :last_name => "Rodriguez",
        :phone => "4526157",
        :email => "pablo@rodriguez.com",
        :password => "test12345",
        :password_confirmation => "test12345",
        
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
    assert_redirected_to new_user_session_path
  end
end