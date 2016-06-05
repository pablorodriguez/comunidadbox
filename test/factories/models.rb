FactoryGirl.define do

  factory :suran, class: Model do
    #id 1
    name "Suran"
    brand {Brand.where("name like ?","Volkswagen").first}
  end

  factory :astra, class: Model do
    #id 2
    name "Astra"
    brand {Brand.where("name like ?","Chevrolet").first}
  end

  factory :bora, class: Model do
    #id 3
    name "Bora"
    brand {Brand.where("name like ?","Volkswagen").first}
  end

  factory :palio, class: Model do
    #id 4
    name "Palio"
    brand {Brand.where("name like ?","Fiat").first}
  end



  
end