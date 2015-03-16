FactoryGirl.define do

  factory :status_open, class: Status do
    name "Abierto"
    is_final false
  end

 factory :status_close, class: Status do
    name "Finalizado"
    is_final true
  end

  
  
end