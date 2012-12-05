FactoryGirl.define do

 factory :mendoza, class: State do
    id 1
    short_name "MDZ"
    name "Mendoza"
    country_id {Country.find(1)}    
  end

end