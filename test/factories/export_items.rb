# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :export_item do
    export nil
    data_type "MyString"
    file_path "MyString"
    file_name "MyString"
  end
end
