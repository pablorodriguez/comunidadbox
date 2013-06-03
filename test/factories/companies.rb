FactoryGirl.define do

  factory :valle_grande_mendoza_plaza, class: Company do
    id 1
    name "Valle Grande Neumaticos-Mendoza (Cnel. Plaza)"    
    phone "0261-4526157"
    website "www.neumaticosvallegrande.com.ar"
    address {FactoryGirl.build(:valle_grande_mendoza_plaza_address)}
  end
  
  factory :valle_grande_mendoza_peru, class: Company do
    id 2
    name "Valle Grande Neumaticos-Mendoza (Peru)"    
    phone "0261-4526157"
    website "www.neumaticosvallegrande.com.ar"
    active 1
    address {FactoryGirl.build(:valle_grande_mendoza_peru_address)}
  end
  

  factory :imr, class: Company do
    id 3
    name "IMR"    
    phone "0261-49494949"
    website "www.imr.com.ar"
    active 1
    address {FactoryGirl.build(:imr_address)}
  end
  
end
