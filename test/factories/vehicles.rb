FactoryGirl.define do

 factory :DDD549, class: Vehicle do
    domain "DDD549"
    vehicle_type "Car"
    model {Model.where("name like ?","Suran").first}
    brand {Brand.where("name like ?","Volkswagen").first}
    year 2009
    km 55000
    kmAverageMonthly 5000
    fuel "Nafta"    
  end

  factory :HRJ549, class: Vehicle do
    domain "HRJ549"
    vehicle_type "Car" 
    model {Model.where("name like ?","Suran").first}
    brand {Brand.where("name like ?","Chevrolet").first}
    year 2010
    km 45000
    kmAverageMonthly 5000
    fuel "Diesel"
  end

  factory :HRJ999, class: Vehicle do
    domain "HRJ999"
    vehicle_type "Car"     
    model {Model.where("name like ?","Suran").first}
    brand {Brand.where("name like ?","Chevrolet").first}
    year 2010
    km 45000
    kmAverageMonthly 5000
    fuel "Diesel"
  end

  factory :HRJE99, class: Vehicle do
    domain "HRJE99"
    vehicle_type "Car"     
    model {Model.where("name like ?","Suran").first}
    brand {Brand.where("name like ?","Chevrolet").first}
    year 2010
    km 45000
    kmAverageMonthly 5000
    fuel "Diesel"
  end
  
end