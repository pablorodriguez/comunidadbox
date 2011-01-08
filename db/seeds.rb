# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
userAdmin = User.create([:first_name =>'Admin',:last_name =>'Admin',
  :email =>'admin@comunidadbox.com',:password =>'admintest'])[0]

company = Company.create([:name =>'ComunidadBox',:phone =>'0261-4526157',
    :website=>'www.comunidadbox.com',:user_id =>userAdmin.id,:active=>1])[0]

[
  {:name =>'super_admin',:detail =>'Super Admin'},
  {:name =>'user',:detail =>'Usuario'},
  {:name =>'employee',:detail =>'Employee'},
  {:name =>'operator',:detail =>'Operator'},
  {:name =>'administrator',:detail =>'Administrator'},
].each do |attributes|
  Role.create(attributes)
end

ServiceType.create([:name=>'Cambio de Aceite',:kms=>10000,:active=>1])
ServiceType.create([:name=>'Cambio de Neumaticos',:kms=>50000,:active=>1])
ServiceType.create([:name=>'Alineacion y Balanceo',:kms=>12000,:active=>1])
ServiceType.create([:name=>'Mantenimiento General',:kms=>20000,:active=>1])
ServiceType.create([:name=>'Tren Delantero',:kms=>60000,:active=>1])
ServiceType.create([:name=>'Suspension',:kms=>60000,:active=>1])
ServiceType.create([:name=>'Frenos / Embragues',:kms=>10000,:active=>1])
ServiceType.create([:name=>'Amortiguacion',:kms=>10000,:active=>1])

ServiceType.all.each do |service_type|
  CompanyService.create([:company_id=> company.id,:service_type_id=>service_type.id])
end

Country.create([:name =>'Argentina'])
Country.create([:name =>'Brazil'])
Country.create([:name =>'Chile'])


PriceList.create([:name =>'Default Price List',:active =>1,:company_id => company.id])

UserRole.create([:user_id => userAdmin.id,:role_id => Role.find_by_name('super_admin').id,:company_id => company.id])
UserRole.create([:user_id => userAdmin.id,:role_id => Role.find_by_name('administrator').id,:company_id => company.id])
