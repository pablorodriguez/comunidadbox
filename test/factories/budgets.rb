FactoryGirl.define do

  factory :budget_one, class: Budget do
    services {[FactoryGirl.build(:service_oc_b,:service_type => ServiceType.where("company_id = ? and name like ?",company.id,"Cambio de Aceite").first)]}
  end

  factory :budget_hrj549, class: Budget do
    services {[FactoryGirl.build(:service_oc_b,:service_type => ServiceType.where("company_id = ? and name like ?",company.id, "Cambio de Aceite").first)]}
  end

  factory :budget_two, class: Budget do
    services {[FactoryGirl.build(:service_oc_b,:service_type =>ServiceType.where("company_id = ? and name like ?", company.id,"Cambio de Aceite").first)]}
    first_name "Martin"
    last_name "Alvarez"
    phone "34355"    
    model {Model.where("name like ?","Suran").first}
    brand {Brand.where("name like ?","Volkswagen").first}
  end

  factory :service_oc_b, class: Service do
    material_services {[build(:material_service_oc_b)]}
  end

  factory :material_service_oc_b, class: MaterialService do
    material_service_type {MaterialServiceType.all.first}
    amount 2
    price 30
  end

end