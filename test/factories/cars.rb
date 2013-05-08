FactoryGirl.define do

 factory :DDD549, class: Car do
    domain "DDD549"
    model {Model.find(1)}
    brand {Brand.find(1)}
    year 2009
    km 55000
    kmAverageMonthly 5000
    fuel "Nafta"    
  end

  factory :HRJ549, class: Car do
    domain "HRJ549"    
    model {Model.find(1)}
    brand {Brand.find(2)}
    year 2010
    km 45000
    kmAverageMonthly 5000
    fuel "Diesel"
  end

  factory :HRJ999, class: Car do
    domain "HRJ999"    
    model {Model.find(1)}
    brand {Brand.find(2)}
    year 2010
    km 45000
    kmAverageMonthly 5000
    fuel "Diesel"
  end
  
end