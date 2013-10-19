FactoryGirl.define do

  factory :so_change_oil, class: ServiceOffer do    
    price 500
    final_price 375
    percent 25
    status Status::SENT
    comment "Nuevo Cambio de Aceite"
    title "Nuevo Cambio de Aceite"
    service_type_id 1
  end

  
end