FactoryGirl.define do

  sequence :material_id do |n|
    "#{n}"
  end

  sequence :code do |n|
    "CC0000#{n}"
  end

  sequence :prov_code do |n|
    "pcode#{n}"
  end

  factory :hand_work_material , class: Material do 
    id 1
    code "MM00001"    
    prov_code "MM00001"
    name "Mano de Obra" 
  end


  factory :material , class: Material do 
    id {generate(:material_id)}
    code {generate(:code)}
    prov_code {generate(:prov_code)}
    name "12.4-28/13.6-28 (Valv TR218A - 5 Und/Caja)" 
  end

 
end