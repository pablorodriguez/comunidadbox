FactoryGirl.define do

  factory :cash, class: PaymentMethod do
    name "Efectivo"
  end
  
  factory :credit_card, class: PaymentMethod do
    name "Tarjeta de Credito"
  end

  factory :debit_card, class: PaymentMethod do
    name "Tarjeta de Debito"
  end

  factory :check, class: PaymentMethod do
    name "Cheque"
  end
end