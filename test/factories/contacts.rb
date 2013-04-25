# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact do
    from "MyString"
    name "MyString"
    message "MyText"
  end
end
