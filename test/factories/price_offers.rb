# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :price_offer do
    offer "MyText"
    workorder nil
    user nil
    confirmed false
  end
end
