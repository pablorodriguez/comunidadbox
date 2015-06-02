FactoryGirl.define do

  factory :vw, class: Brand do
    id 1
    name "Volkswagen"
    of_cars true
  end

 factory :chevrolet, class: Brand do
    id 2
    name "Chevrolet"
    of_cars true
  end

  factory :fiat, class: Brand do
    id 3
    name "Fiat"
    of_cars true
  end

  
  
end