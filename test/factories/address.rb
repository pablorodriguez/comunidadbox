
FactoryGirl.define do

  factory :test_address, class: Address do
    id 1
    state {State.find(1)}
    zip 5500
    street "Cnel Plaza 72"
    city "Mendoza"
  end
  
  factory :test_2_address, class: Address do
    id 2
    state {State.find(1)}
    zip 5500
    street "AV Peru 1667"
    city "Mendoza"
  end
  
  factory :imr_address, class: Address do
    id 3
    state {State.find(1)}
    zip 5624
    street "Rio Negro S/N"
    city "Real del Padre"
  end

  factory :combox_address, class: Address do
    id 4
    state {State.find(1)}
    zip 5500
    street "Cnel Plaza 72"
    city "Mendoza"
  end
  
end