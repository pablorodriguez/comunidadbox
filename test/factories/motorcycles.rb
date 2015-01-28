FactoryGirl.define do

  factory :m549HRJ, class: Motorcycle do
    domain "549HRJ"
    model {Model.find(1)}
    brand {Brand.find(2)}
    year 2010
    km 45000
    kmAverageMonthly 5000
    fuel "Nafta"
    chassis "549HRJ"
  end

  factory :m999HRJ, class: Motorcycle do
    domain "999HRJ"    
    model {Model.find(1)}
    brand {Brand.find(2)}
    year 2010
    km 45000
    kmAverageMonthly 5000
    fuel "Diesel"
    chassis "999HRJ"
  end
  
end