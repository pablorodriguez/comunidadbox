FactoryGirl.define do

  factory :suran, class: Model do
    name "Suran"
    brand factory: :vw
  end

  factory :astra, class: Model do
    name "Astra"
    brand factory: :chevrolet
  end

  
end