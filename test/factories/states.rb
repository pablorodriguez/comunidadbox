FactoryGirl.define do

 factory :mendoza, class: State do
    id 1
    short_name "MDZ"
    name "Mendoza"
    association :country, factory: :argentina
  end

end