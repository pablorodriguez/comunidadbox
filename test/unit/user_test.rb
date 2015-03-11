# coding: utf-8
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  setup do
    Address.any_instance.stubs(:geocode).returns([1,1]) 

    create_all_default_data
    @pablo =  create(:pablo_rodriguez)
    @gustavo =  create(:gustavo_de_antonio)
    create_all_company_data @gustavo.company_id
    
    @marcelo =  create(:marcelo_de_antonio)
    @emp_walter =  create(:emp_walter)    
    @new_pablo =  create(:new_pablo_rodriguez)

    @imr_admin =  create(:imr_admin)
    @imr_emp =  create(:imr_emp)
  end

  test "user is employee" do   
    assert @marcelo.is_employee?, "Marcelo de Antonio no es empleado"
    assert @gustavo.is_employee?, "Gustavo de Antonio no es empleado"
    assert @pablo.is_employee? == false, "Pablo Rodriguez no es empleado"
    assert @emp_walter.is_employee?, "Walter no es empleado"
  end

  test "employeer cant edit confirmed user" do   
    assert @gustavo.can_edit?(@pablo) == false
  end

  test "employeer can edit new client not confirmed" do
    @wo = create(:wo_oc,:car => @new_pablo.cars.first,:user => @gustavo,:company => @gustavo.company,:status_id => 2)    
    assert @gustavo.can_edit?(@new_pablo)
  end

  test "employeer cant edit other company client" do
    @wo = create(:wo_oc,:car => @new_pablo.cars.first,:user => @imr_emp,:company => @imr_emp.company,:status_id => 2)
    assert @gustavo.can_edit?(@new_pablo) == false
  end

  test "import new clients" do

    create(:service_on_warranty)

    csv_rows = <<-eos
    Id externo,Nombre,Apellido,Tel_fono,Email,CUIT,RazÑn Social,Provincia,Ciudad,Calle,CÑdigo Postal,Dominio,Marca,Modelo,Combustible,A_o,Kilometraje promedio mensual,Kilometraje,Tipo de Servicio,Fecha
    123456,Jaime,,2616585858,jaimito8@jaime.com,,,Mendoza,Mendoza,Beltran 158,5500,UGB376,Fiat2,Palio2,Diesel,2000,2000,252025,Servicio en Garantía,1/6/15
    AAA12345,Leonardo,Ruggeri,2615568584,legaru@gmail.com,,,Mendoza,Mendoza,Beltran 1758,5501,JBY091,Volkswagen,Suran,Nafta,2010,2000,70000,Servicio en Garantía,1/7/2015
    eos

    file = Tempfile.new('new_users.csv',:encoding => 'iso-8859-1')
    file.write(csv_rows)
    file.rewind

    result = []
    assert_difference('Company.clients(@gustavo.get_companies_ids,{}).size') do
      result = User.import_clients file,@gustavo,@gustavo.company_active.id
    end

    assert result[:errors].size == 1
    assert result[:failure] == 1
    assert result[:total_records] == 2, "Error in number of recrods"
    assert result[:success] == 1

    csv_rows = <<-eos
    Id externo,Nombre,Apellido,Tel_fono,Email,CUIT,RazÑn Social,Provincia,Ciudad,Calle,Codigo Postal,Dominio,Marca,Modelo,Combustible,Ano,Kilometraje promedio mensual,Kilometraje,Tipo de Servicio,Fecha
    AAA12345,Pablo,Ruggeri,2615568584,legaru@gmail.com,,,Mendoza,Mendoza,Beltran 1758,5501,JBY091,Volkswagen,Suran,Nafta,2014,2000,70000,Servicio en Garantía,1/7/2015
    eos

    file = Tempfile.new('new_users.csv',:encoding => 'iso-8859-1')
    file.write(csv_rows)
    file.rewind

    result = User.import_clients file,@gustavo,@gustavo.company_active.id

    client = User.find_by_external_id("AAA12345")
    car = client.cars.first

    assert client.first_name == "Pablo"
    assert car.year == 2014
    assert I18n.l(car.events.first.dueDate) == '01/07/2015'
    assert client.cars.size == 1

    csv_rows = <<-eos
    Id externo,Nombre,Apellido,Tel_fono,Email,CUIT,RazÑn Social,Provincia,Ciudad,Calle,Codigo Postal,Dominio,Marca,Modelo,Combustible,Ano,Kilometraje promedio mensual,Kilometraje,Tipo de Servicio,Fecha
    AAA12345,Pablo,Ruggeri,2615568584,legaru@gmail.com,,,Mendoza,Mendoza,Beltran 1758,5501,EJE688,Volkswagen,Bora,Nafta,2012,2000,70000,Servicio en Garantía,1/7/2016
    eos

    file = Tempfile.new('new_users.csv',:encoding => 'iso-8859-1')
    file.write(csv_rows)
    file.rewind

    result = User.import_clients file,@gustavo,@gustavo.company_active.id
    client = User.find_by_external_id("AAA12345")

    assert client.cars.size == 2

  
  end

end