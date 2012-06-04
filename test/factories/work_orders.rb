FactoryGirl.define do

  factory :wo_1, class: Workorder do    
    #car factory: :HRJ549
    #user factory: :gustavo_de_antonio
    association :payment_method, :factory => :check
    services {[FactoryGirl.build(:service)]}
  end

  factory :service, class: Service do
    service_type {FactoryGirl.create(:oil_change)}
    status 4
    material_services {[FactoryGirl.build(:material_service)]}
  end

  factory :material_service, class: MaterialService do
    association :material_service_type, :factory =>:hand_work_oil_change
    amount 2
    price 30
  end
end