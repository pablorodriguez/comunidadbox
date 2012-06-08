FactoryGirl.define do

  factory :wo_1, class: Workorder do            
    services {[FactoryGirl.build(:service)]}
  end

  factory :service, class: Service do    
    service_type {ServiceType.find(1)}
    status 4
    material_services {[build(:material_service)]}
  end

  factory :material_service, class: MaterialService do
    material_service_type {MaterialServiceType.find(1)}
    amount 2
    price 30
  end

end