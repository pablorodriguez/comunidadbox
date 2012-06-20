FactoryGirl.define do

  factory :budget_one, class: Budget do
    services {[FactoryGirl.build(:service_oc_b)]}
  end

  factory :budget_two, class: Budget do
    services {[FactoryGirl.build(:service_oc_b)]}
    first_name "Martin"
    last_name "Alvarez"
    phone "34355"    
    model {Model.find(1)}
    brand {Brand.find(1)}
  end

  factory :service_oc_b, class: Service do
    service_type {ServiceType.find(1)}
    status 4
    material_services {[build(:material_service_oc_b)]}
  end

  factory :material_service_oc_b, class: MaterialService do
    material_service_type {MaterialServiceType.find(1)}
    amount 2
    price 30
  end

end