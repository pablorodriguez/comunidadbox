# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_service_request do
    service_request_id 1
    service_type_id 1
    description "MyText"
    date_from "2013-10-30"
    date_to "2013-10-30"
    price 1.5
  end
end
