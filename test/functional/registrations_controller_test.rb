require 'test_helper'

class Users::RegistrationsControllerTest < ActionController::TestCase
  
  setup do  
    create_all_default_data
    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
    
  end


  test "should register a user" do
    VCR.use_cassette 'portugal1234' do
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
        },
        :user_type =>1
      end
      assert_redirected_to new_user_session_path
    end
  end

  test "show register page" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    get :new
    assert_response :success
    assert_template :new    
    assert_select("div",:id=>"recaptcha_area",:count=>1)    
    
  end

  test "register service center" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    VCR.use_cassette 'portugal1234',:match_requests_on => [:body] do
      ##User.any_instance.stubs(:verify_recaptcha).returns(true)
      assert_difference('User.count',1,"no hay nuevos usuarios") do
        post :create, :user => {
          :first_name => "Pablo",
          :last_name => "Rodriguez",
          :phone => "4526157",
          :email => "pablo@rodriguez.com",        
          :password => "test12345",
          :active => 1,
          :password_confirmation => "test12345",
          
          :companies_attributes => [
            {
              :name => "IMER",
              :cuit => "345678866",
              :address_attributes => {
                :city =>"Godoy Cruz",
                :street => "Portugal 1324",
                :zip => "5501",
                :state_id => State.find(1).id
            }
          }]
        },
        :user_type =>2
      end
    end
    assert_redirected_to new_user_session_path
    user = User.find_by_email("pablo@rodriguez.com")      
    assert user.companies.first.active == true

  end

end