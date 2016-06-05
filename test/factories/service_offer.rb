FactoryGirl.define do

  factory :so_change_oil, class: ServiceOffer do    
    price 500
    final_price 375
    percent 25
    status Status::SENT
    comment "Nuevo Cambio de Aceite"
    title "Nuevo Cambio de Aceite"
    offer_service_types {[OfferServiceType.new(service_type_id: ServiceType.where("company_id = ? and name like ?",company.id,"Cambio de Aceite").first.id)]}
  end

  factory :so_ad_1_day, class: ServiceOffer do    
    price 500
    final_price 250
    percent 50
    status Status::CONFIRMED
    comment "Cambio de Aceite" 
    title "Cambio de Aceite Publicidad"
    since Date.parse("01/01/2014")    
    offer_service_types {[OfferServiceType.new(service_type_id: ServiceType.where("company_id = ? and name like ?",company.id,"Cambio de Aceite").first.id)]}    
  end
  
  factory :advertisement_1,class: Advertisement do
    advertisement_days {[FactoryGirl.build(:advertisement_day_2_day_since),FactoryGirl.build(:advertisement_day_3_day_since)]}
  end

  factory :advertisement_day_2_day_since,class: AdvertisementDay do
    published_on 2.days.since
  end

  factory :advertisement_day_3_day_since,class: AdvertisementDay do
    published_on 3.days.since
  end
  
  factory :so_ad_2_day, class: ServiceOffer do    
    price 500
    final_price 250
    percent 50
    status Status::CONFIRMED
    comment "Cambio de Aceite" 
    title "Cambio de Aceite Publicidad"
    since Date.parse("01/01/2014")    
    offer_service_types {[OfferServiceType.new(service_type_id: ServiceType.where("company_id = ? and name like ?",company.id,"Cambio de Aceite").first.id)]}    
    advertisement FactoryGirl.build(:advertisement_1)    
  end

  
end