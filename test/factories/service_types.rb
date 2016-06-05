# coding: utf-8

FactoryGirl.define do


  factory :oil_change, class: ServiceType do
    #id 1
    name "Cambio de Aceite"
    kms 10000
    active 1
  end

  factory :tire_change, class: ServiceType do    
    #id 2
    name "Cambio de Neumaticos"
    kms 50000
    active 1
  end

  factory :alignment_and_balancing, class: ServiceType do
    #id 3
    name "Alineacion y Balanceo"
    kms 40000
    active 1
  end

  factory :general_maintenance, class: ServiceType do
    #id 4
    name "Mantenimiento General"    
    active 1
  end

  factory :front, class: ServiceType do
    #id 5
    name "Tren Delantero"
    kms 60000    
    active 1
  end

  factory :suspension, class: ServiceType do
    #id 7
    name "Suspension"    
    active 1
  end

  factory :break_clutch, class: ServiceType do
    #id 8
    name "Frenos / Embragues"
    kms 60000    
    active 1  
  end

  factory :buffer, class: ServiceType do
    #id 9
    name "Amortiguacion"
    kms 60000
    active 1      
  end
  
  factory :service_on_warranty, class: ServiceType do
    #id 10
    name "Servicio en Garantía"
    kms 0
    active 1      
  end
end

