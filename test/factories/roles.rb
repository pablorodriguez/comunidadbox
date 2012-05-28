FactoryGirl.define do

  factory :super_admin, class: Role do
    id -1
    name "super_admin"
    detail "Super Admin"
  end

  factory :employee, class: Role do  
    id 2
    name "employee"
    detail "Empleado"
  end

  factory :user, class: Role do
    id -2
    name "user"
    detail "Usuario"
  end
  
  factory :operator, class: Role do
    id 4
    name "operator"
    detail "Operario"
  end
  
  factory :administrator, class: Role do
    id 5
    name "administrator"
    detail "Administrador"
  end

  factory :manager, class: Role do
    id 6
    name "manager"
    detail "Gerente General"
  end

end