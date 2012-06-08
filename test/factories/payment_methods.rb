FactoryGirl.define do

  factory :cash, class: PaymentMethod do
    id 1
    name "Efectivo"
  end
  
  factory :credit_card, class: PaymentMethod do
    id 2
    name "Tarjeta de Credito"
  end

  factory :debit_card, class: PaymentMethod do
    id 3
    name "Tarjeta de Debito"
  end

  factory :check, class: PaymentMethod do
    id 4
    name "Cheque"
  end
end