FactoryGirl.define do

  factory :m_s, class: MaterialService do
    price 1000
    amount 2
    association :material_service_type, :factory => :hand_work_for_tire_change
  end


  factory :tire_change_service, class: Service do
    association :service_type, :factory => :tire_change
    association :material_services, :factory => :m_s    
  end

  factory :budget_one, class: Budget do
    services {[FactoryGirl.create(:tire_change_service)]}
  end
end