FactoryGirl.define do

  factory :hrj549_so, class: VehicleServiceOffer do
    id 1
    state {State.find(1)}
    zip 5500
    street "Cnel Plaza 72"
    city "Mendoza"
  end
  
  
  
end