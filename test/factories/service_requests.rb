# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :sr, class: ServiceRequest do    
    user {User.find_by_email("pablo@comunidadbox.com")}
    vehicle {Vehicle.find_by_domain("HRJ549")}
    status Status::OPEN    
  end

end
