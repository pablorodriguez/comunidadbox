# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :company_attribute do
    company_id 1
    key "MyString"
    value ""
  end
end
