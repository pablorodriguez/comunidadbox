# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service_request do
    user_id 1
    car_id 1
    status 1
    company_id 1
  end
end
