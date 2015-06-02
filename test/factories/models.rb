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

  factory :bora, class: Model do
    id 3
    name "Bora"
    brand {Brand.find(1)}
  end

  factory :palio, class: Model do
    id 4
    name "Palio"
    brand {Brand.find(3)}
  end



  
end