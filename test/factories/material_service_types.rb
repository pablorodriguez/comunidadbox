FactoryGirl.define do
  factory :hand_work_for_tire_change, class: MaterialServiceType do   
    service_type factory: :tire_change
  end
end
