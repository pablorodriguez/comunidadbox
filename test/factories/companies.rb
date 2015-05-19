FactoryGirl.define do

  factory :valle_grande_mendoza_plaza, class: Company do
    id 1
    name "Valle Grande Neumaticos-Mendoza (Cnel. Plaza)"    
    phone "0261-4526157"
    website "www.neumaticosvallegrande.com.ar"
    active 1
    address {FactoryGirl.build(:test_address)}
    headquarter 1
    after(:build) do |company|
      company.statuses << FactoryGirl.build(:status_open,:id=>1)
      company.statuses << FactoryGirl.build(:status_close,:id=>2)
    end
  end
  
  factory :valle_grande_mendoza_peru, class: Company do
    id 2
    name "Valle Grande Neumaticos-Mendoza (Peru)"    
    phone "0261-4526157"
    website "www.neumaticosvallegrande.com.ar"
    active 1
    address {FactoryGirl.build(:test_2_address)}
    after(:build) do |company|
      company.statuses << FactoryGirl.build(:status_open,:id=>3)
      company.statuses << FactoryGirl.build(:status_close,:id=>4) 
    end

  end
  

  factory :imr, class: Company do
    id 3
    name "IMR"    
    phone "0261-49494949"
    website "www.imr.com.ar"
    active 1
    address {FactoryGirl.build(:imr_address)}
    after(:build) do |company|
      company.statuses << FactoryGirl.build(:status_open,:id=>5)
      company.statuses << FactoryGirl.build(:status_close,:id=>6) 
    end

  end
  
end
