FactoryGirl.define do

  factory :wo_1, class: Workorder do            
    services {[FactoryGirl.build(:service)]}
  end

  factory :service, class: Service do    
    association :service_type, factory: :oil_change
    status 4
    material_services {[build(:material_service)]}
  end

  factory :material_service, class: MaterialService do
    association :material_service_type, factory: :hand_work_oil_change
    amount 2
    price 30
  end

  factory :hand_work_oil_change, class: MaterialServiceType do   
    service_type {ServiceType.find(1)}
    material factory: :hand_work_material
  end

  factory :hand_work_material , class: Material do 
    name "Mano de Obra" 
    prov_code "MM00001"
    code "MM00001"    
  end


end