FactoryGirl.define do

  factory :wo_oc, class: Workorder do
    services {[FactoryGirl.build(:service_oc,:status_id => status_id)]}
    payment_method {PaymentMethod.where("name like ?","Efectivo").first}
    deliver 1.hour.since
  end

  factory :wo_oc_open, class: Workorder do            
    services {[FactoryGirl.build(:service_oc_open,:status_id => status_id)]}
    payment_method {PaymentMethod.where("name like ?","Efectivo").first}
    deliver 1.hour.since
  end

  factory :service_oc_open, class: Service do
    service_type {ServiceType.where("name like ?","Cambio de Aceite").first}
    material_services {[build(:material_service_oc)]}
  end

  factory :service_oc, class: Service do
    service_type {ServiceType.where("name like ?","Cambio de Aceite").first}
    material_services {[build(:material_service_oc)]}
  end

  factory :material_service_oc, class: MaterialService do
    material_service_type {MaterialServiceType.all.first}
    amount 2
    price 30
  end

  factory :wo_tc, class: Workorder do            
    services {[FactoryGirl.build(:service_tc,:status_id => status_id)]}
    payment_method {PaymentMethod.where("name like ?","Efectivo").first}
    deliver 1.hour.since
  end

  factory :service_tc, class: Service do
    service_type {ServiceType.where("name like ?","Cambio de Neumaticos").first}
    material_services {[build(:material_service_tc)]}
  end

  factory :material_service_tc, class: MaterialService do
    material_service_type {MaterialServiceType.all.first}
    amount 2
    price 30
  end



end