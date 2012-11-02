FactoryGirl.define do

  factory :alarm_repit, class: Alarm do
    id 1
    name "alarm repit"
    description "alarm repit desc"
    date_alarm 1.hour.since
    status Status::ACTIVE
    user {FactoryGirl.create(:pablo_rodriguez)}
  end
  
end