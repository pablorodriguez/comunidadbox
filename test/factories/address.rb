FactoryGirl.define do

  factory :valle_grande_mendoza_plaza_address, class: Address do
    id 1
    state {State.find(1)}
    zip 5500
    street "Cnel Plaza 72"
    city "Mendoza"
  end
  
  factory :valle_grande_mendoza_peru_address, class: Address do
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
  
end