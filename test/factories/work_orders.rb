FactoryGirl.define do

  factory :wo_1, class: Workorder do    
    car factory: :HRJ5R9
    user factory: :gustavo_de_antonio
    payment_method factory: :check
    services {[FactoryGirl.create(:service)]}
  end

  factory :service, class: Service do
    service_type {FactoryGirl.create(:oil_change)}
      status 4
      material_services {[FactoryGirl.create(:materila_service)]}
  end

  factory :material_service, class: MaterialService do
    material_service_type {FactoryGirl.create(:hand_work_oil_change)}
    amount 2
    price 30
  end
end