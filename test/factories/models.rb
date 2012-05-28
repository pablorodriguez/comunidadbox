FactoryGirl.define do

  factory :suran, class: Model do
    name "Suran"
    brand factory: :vw
  end
  
end