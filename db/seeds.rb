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

Company.create([:name=>"Argentina"])

PriceList.create([:name =>'Default Price List',:active =>1,:company_id => company.id])
