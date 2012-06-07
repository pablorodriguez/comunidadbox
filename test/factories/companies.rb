FactoryGirl.define do

  
  factory :valle_grande_mendoza_peru, class: Company do
    name "Valle Grande Neumaticos-Mendoza (Peru)"    
    phone "0261-4526157"
    website "www.neumaticosvallegrande.com.ar"
    active 1
    #company_service {[FactoryGirl.create(:company_oil_change),FactoryGirl.create(:company_tire_change)]}
  end
  
  factory :valle_grande_mendoza_plaza, class: Company do
    name "Valle Grande Neumaticos-Mendoza (Cnel. Plaza)"    
    phone "0261-4526157"
    website "www.neumaticosvallegrande.com.ar"
  end

  
end
