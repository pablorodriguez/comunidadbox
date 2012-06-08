FactoryGirl.define do

  factory :wo_oc, class: Workorder do            
    services {[FactoryGirl.build(:service_oc)]}
    payment_method {PaymentMethod.find(1)}
  end

  factory :service_oc, class: Service do
    service_type {ServiceType.find(1)}
    status 4
    material_services {[build(:material_service_oc)]}
  end

  factory :material_service_oc, class: MaterialService do
    material_service_type {MaterialServiceType.find(1)}
    amount 2
    price 30
  end

  factory :wo_tc, class: Workorder do            
    services {[FactoryGirl.build(:service_tc)]}
    payment_method {PaymentMethod.find(1)}
  end

  factory :service_tc, class: Service do
    service_type {ServiceType.find(2)}
    status 4
    material_services {[build(:material_service_tc)]}
  end

  factory :material_service_tc, class: MaterialService do
    material_service_type {MaterialServiceType.find(1)}
    amount 2
    price 30
  end



end