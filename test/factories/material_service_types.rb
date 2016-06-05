FactoryGirl.define do

  factory :hand_work_oil_change, class: MaterialServiceType do
    service_type {ServiceType.where("name like ?","Cambio de Aceite").first}
    material {Material.where("name like ?","Mano de Obra").first}
  end

  factory :hand_work_for_tire_change, class: MaterialServiceType do   
    service_type {ServiceType.where("name like ?","Cambio de Neumaticos").first}
    material {Material.where("name like ?","Mano de Obra").first}
  end
  
end
