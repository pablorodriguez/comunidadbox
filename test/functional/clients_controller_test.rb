require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  
  setup do  
    create_all_default_data   
    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
  end


  test "should create a client with a car" do
    car = build("HRJ549")
    @request.cookies["company_id"]= @employer.company.id.to_s

    VCR.use_cassette 'portugal1234' do
      sign_in @employer
      assert_difference('User.count',1,"no hay nuevos clientes") do
        post :create, :user => {
          :first_name => "Pablo",
          :last_name => "Rodriguez",
          :phone => "4526157",
          :email => "pablo@rodriguez.com",
          
          :vehicles_attributes => [
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
    end

    new_client = User.where("email like ?","pablo@rodriguez.com").first
    assert_redirected_to new_workorder_path(:vehicle_id =>new_client.vehicles.first.id)
    assert new_client.vehicles.first.vehicle_type =="Car"
    assert @employer.is_client?(new_client)
  end
  
  test "should create a client with a motorcycle" do
    motorcycle = build("m549HRJ")
    @request.cookies["company_id"]= @employer.company.id.to_s
    sign_in @employer
    VCR.use_cassette 'portugal1234' do
      assert_difference('User.count',1,"no hay nuevos clientes") do
        post :create, :user => {
          :first_name => "Pablo",
          :last_name => "Rodriguez",
          :phone => "4526157",
          :email => "pablo@rodriguez.com",
          
          :vehicles_attributes => [
            {
              :domain => motorcycle.domain,
              :vehicle_type => "Motorcycle",
              :brand_id => motorcycle.brand_id,
              :model_id => motorcycle.model_id,
              :kmAverageMonthly => motorcycle.kmAverageMonthly,
              :km => motorcycle.km,
              :year => motorcycle.year
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
    end
    new_client = User.where("email like ?","pablo@rodriguez.com").first
    assert @employer.is_client?(new_client)
    assert new_client.vehicles.first.is_motorcycle?
    assert_redirected_to new_workorder_path(:vehicle_id =>new_client.vehicles.first.id)
  end

  test "should create a client with error" do
    car = build("HRJ549")
    @request.cookies["company_id"]= @employer.company.id.to_s

    VCR.use_cassette 'portugal1234' do
      sign_in @employer
      assert_difference('User.count',0,"no hay nuevos clientes") do
        post :create, :user => {
          :first_name => "Pablo",
          :last_name => "Rodriguez",
          :phone => "4526157",          
          :vehicles_attributes => [
            {
              :domain => car.domain,
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
    end

    assert_template :new
    
  end

  test "employee should create a client from a budget with vehicle info" do
    skip("implement this .....")
  end

  test "owner should create a client from a budget with vehicle info" do
    skip("implement this .....")
  end

test "employee should create a client from a budget with no vehicle info" do
    skip("implement this .....")
  end

  test "owner should create a client from a budget with no vehicle info" do
    skip("implement this .....")
  end

  
end