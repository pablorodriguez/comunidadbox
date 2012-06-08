FactoryGirl.define do

  factory :hand_work_oil_change, class: MaterialServiceType do
    id 1
    service_type {ServiceType.find(1)}
    material {Material.find(1)}
  end

  factory :hand_work_for_tire_change, class: MaterialServiceType do   
    id 2
    service_type {ServiceType.find(2)}
    material {Material.find(1)}
  end
  
end
