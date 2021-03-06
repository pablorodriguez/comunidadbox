# coding: utf-8
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  setup do

    create_all_default_data
    @gustavo =  create(:gustavo_de_antonio)
    create_all_company_data @gustavo.company_id
    @pablo =  create(:pablo_rodriguez)
    @marcelo =  create(:marcelo_de_antonio)
    @emp_walter =  create(:emp_walter)    
    @new_pablo =  create(:new_pablo_rodriguez)

    @imr_admin =  create(:imr_admin)
    create_all_company_data @imr_admin.company_id
    @imr_emp =  create(:imr_emp)
  end

  test "user with duplicate domain" do
    @pablo.vehicles << FactoryGirl.build(:HRJ549)
    assert @pablo.valid?
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
    @wo = create(:wo_oc,:vehicle => @new_pablo.cars.first,:user => @gustavo,:company => @gustavo.company,:status_id => 2)    
    assert @gustavo.can_edit?(@new_pablo)
  end

  test "employeer cant edit other company client" do
    @wo = create(:wo_oc,:vehicle => @new_pablo.cars.first,:user => @imr_emp,:company => @imr_emp.company,:status_id => 2)
    assert @gustavo.can_edit?(@new_pablo) == false
  end

  test "import new clients all ok" do

    create :service_on_warranty,:company_id => @gustavo.company_active.id


    csv_rows = <<-eos
    Id externo,Fecha,Nombre,Apellido,Teléfono,Email,CUIT,Razón Social,Provincia,Ciudad,Calle,Código Postal,Dominio,Marca,Modelo,Serie,Combustible,Año,Kilometraje promedio mensual,Kilometraje,Tipo de Servicio,Fecha
    123456,22/05/2015,Jaime,Dardo,2616585858,jaimito8@jaime.com,,,Mendoza,Mendoza,Beltran 158,5500,UGB376,Fiat2,Palio,RR3444,Diesel,2000,2000,252025,Servicio en Garantía,1/6/15
    AAA12345,22/05/2015,Leonardo,Ruggeri,2615568584,legaru@gmail.com,,,Mendoza,Mendoza,Beltran 1758,5501,JBY091,Volkswagen,Suran,FGT555,Nafta,2010,2000,70000,Servicio en Garantía,1/7/2015
    eos

    file = Tempfile.new('new_users.csv',:encoding => 'iso-8859-1')
    file.write(csv_rows)
    file.rewind

    def file.original_filename
        "test.csv"
    end

    result = []
    result = User.import_clients file,@gustavo,@gustavo.company_active.id,'iso-8859-1'
    assert result[:errors].size == 0, "There is error"
    assert result[:failure] == 0, "Error in number of failure"
    assert result[:success] == 2, "Error in number of success"

    vehicle = Vehicle.where("chasis = ?","RR3444")
    assert vehicle

  end

  test "import new clients minimal info" do

    create :service_on_warranty,:company_id => @gustavo.company_active.id


    csv_rows = <<-eos
    Id externo,Fecha,Nombre,Apellido,Teléfono,Email,CUIT,Razón Social,Provincia,Ciudad,Calle,Código Postal,Dominio,Marca,Modelo,Serie,Combustible,Año,Kilometraje promedio mensual,Kilometraje,Tipo de Servicio,Fecha
    123456,22/05/2015,,,,,,,,,,,DDD333,Fiat,Palio,RR3444,Diesel,2000,2000,252025,Servicio en Garantía,1/6/15
    eos

    file = Tempfile.new('new_users.csv',:encoding => 'iso-8859-1')
    file.write(csv_rows)
    file.rewind
    def file.original_filename
        "test.csv"
    end
    
    result = []
    result = User.import_clients file,@gustavo,@gustavo.company_active.id,'iso-8859-1'
    
    assert result[:errors].size == 0, "Error in number of errors"
    assert result[:failure] == 0, "Error in number of failure"
    assert result[:total_records] == 1, "Error in number of records"
    assert result[:success] == 1, "Error in number of success"

    vehicle = Vehicle.where("chasis = ?","RR3444")
    assert vehicle

  end

  test "import new clients" do
    create :service_on_warranty,:company_id => @gustavo.company_active.id

    csv_rows = <<-eos
    Id externo,Fecha,Nombre,Apellido,Tel_fono,Email,CUIT,Razón Social,Provincia,Ciudad,Calle,Codigo Postal,Dominio,Marca,Modelo,Serie,Combustible,Ano,Kilometraje promedio mensual,Kilometraje,Tipo de Servicio,Fecha
    AAA12345,22/05/2015,Pablo,Ruggeri,2615568584,legaru@gmail.com,,,Mendoza,Mendoza,Beltran 1758,5501,JBY091,Volkswagen,Suran,,Nafta,2014,2000,70000,Servicio en Garantía,1/7/2015
    eos

    file = Tempfile.new('new_users.csv',:encoding => 'iso-8859-1')
    file.write(csv_rows)
    file.rewind
    def file.original_filename
        "test.csv"
    end

    result = User.import_clients file,@gustavo,@gustavo.company_active.id,'iso-8859-1'
    client = User.find_by_external_id("AAA12345")
    car = client.vehicles.first

    assert client.first_name == "Pablo"
    assert car.year == 2014
    assert I18n.l(car.events.first.dueDate) == '01/07/2015'
    assert client.vehicles.size == 1

    assert Company.clients({:last_name => "Ruggeri",:companies_ids => @gustavo.get_companies_ids}).size == 1
    csv_rows = <<-eos
    Id externo,Fecha,Nombre,Apellido,Tel_fono,Email,CUIT,Razón Social,Provincia,Ciudad,Calle,Codigo Postal,Dominio,Marca,Modelo,Serie,Combustible,Ano,Kilometraje promedio mensual,Kilometraje,Tipo de Servicio,Fecha
    AAA12345,22/05/2015,AntonioPablo,Rossi,2615568584,pabloantonio@gmail.com,,,Mendoza,Mendoza,Beltran 1758,5501,EJE688,Volkswagen,Bora,,Nafta,2012,2000,70000,Servicio en Garantía,1/7/2016
    eos

    file = Tempfile.new('new_users.csv',:encoding => 'iso-8859-1')
    file.write(csv_rows)
    file.rewind
    def file.original_filename
        "test.csv"
    end
    
    result = User.import_clients file,@gustavo,@gustavo.company_active.id,'iso-8859-1'
    client = User.find_by_external_id("AAA12345")
    assert client.vehicles.size == 2
    assert client.last_name == "Rossi"
    assert client.first_name == "AntonioPablo"
    assert client.email == "pabloantonio@gmail.com"

  
  end

end
