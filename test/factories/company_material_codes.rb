# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :company_material_code do
    code "MyString"
    Company nil
    MaterialServiceType nil
  end
end
