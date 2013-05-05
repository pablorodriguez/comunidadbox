FactoryGirl.define do

  factory :valle_grande_mendoza_plaza, class: Company do
    id 1
    name "Valle Grande Neumaticos-Mendoza (Cnel. Plaza)"    
    phone "0261-4526157"
    website "www.neumaticosvallegrande.com.ar"
  end
  
  factory :valle_grande_mendoza_peru, class: Company do
    id 2
    name "Valle Grande Neumaticos-Mendoza (Peru)"    
    phone "0261-4526157"
    website "www.neumaticosvallegrande.com.ar"
    active 1
    #company_service {[FactoryGirl.create(:company_oil_change),FactoryGirl.create(:company_tire_change)]}
  end
  

  factory :imr, class: Company do
    id 3
    name "IMR"    
    phone "0261-49494949"
    website "www.imr.com.ar"
    active 1
  end
  
end
