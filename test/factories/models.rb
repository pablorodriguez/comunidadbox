FactoryGirl.define do

  factory :suran, class: Model do
    id 1
    name "Suran"
    brand {Brand.find(1)}
  end

  factory :astra, class: Model do
    id 2
    name "Astra"
    brand {Brand.find(2)}
  end

  
end