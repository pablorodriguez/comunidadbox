FactoryGirl.define do

  factory :HRJ549, class: Car do
    domain "HRJ549"
    association :model, factory: :suran
    association :brand, factory: :vw
    year 2009
    km 55000
    kmAverageMonthly 1500
    fuel "Nafta"    
  end
  
end