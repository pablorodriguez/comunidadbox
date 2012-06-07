FactoryGirl.define do

 factory :DDD549, class: Car do
    domain "DDD549"
    association :model, factory: :suran
    association :brand, factory: :vw
    year 2009
    km 55000
    kmAverageMonthly 1500
    fuel "Nafta"    
  end

  factory :HRJ549, class: Car do
    domain "HRJ549"
    association :model, factory: :astra
    association :brand, factory: :chevrolet
    year 2010
    km 45000
    kmAverageMonthly 1300
    fuel "Diesel"
  end
  
end