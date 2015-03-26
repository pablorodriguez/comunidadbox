FactoryGirl.define do

  factory :m549HRJ, class: Vehicle do
    domain "549HRJ"
    vehicle_type "Motorcycle"
    model {Model.find(1)}
    brand {Brand.find(2)}
    year 2010
    km 45000
    kmAverageMonthly 5000
    fuel "Nafta"
    chassis "549HRJ"
  end

  factory :m999HRJ, class: Vehicle do
    domain "999HRJ"
    vehicle_type "Motorcycle"
    model {Model.find(1)}
    brand {Brand.find(2)}
    year 2010
    km 45000
    kmAverageMonthly 5000
    fuel "Diesel"
    chassis "999HRJ"
  end
  
end