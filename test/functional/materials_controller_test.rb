require 'test_helper'
      
class MaterialsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do    
    create_all_default_data    
    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
    
    @material1 = create(:material,:id =>100,:company_id => @employer.company_active.id)
    @material2 = create(:material,:id=>101,:company_id => @employer.company_active.id)
  end

  test "upload new materials file" do   
    csv_rows = <<-eos
    id,codigo,codigo proveedor,nombre,marca,provider
    ,CN00492,CAD1016,10/11.00-16 AGRICOLA (Valv TR15 - 8 Und/Caja),,
    100,CN00498,CAT13628,12.4-28/13.6-28 (Valv TR218A - 5 Und/Caja),Test,Prov
    101,CN00508,CV1424,13.00-24/14.00-24 (Valv TR220A - 3 Und/Caja),,
    eos

    file = Tempfile.new('new_users.csv')
    file.write(csv_rows)
    file.rewind

    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @employer
    
    post "import", :file => Rack::Test::UploadedFile.new(file, 'text/csv')

    m = Material.where("company_id = ? and code = ?",@employer.get_company_id_for_materials,"CN00492").first
    assert m.name == "10/11.00-16 AGRICOLA (Valv TR15 - 8 Und/Caja)" 

    m = Material.find(100)
    assert m.brand == "Test"
    assert m.provider == "Prov"
    assert_redirected_to materials_path
  end


  test "upload new materials file for service types" do   
    csv_rows = <<-eos
    id,codigo,codigo proveedor,nombre,marca,provider
    ,CN00492,CAD1016,10/11.00-16 AGRICOLA (Valv TR15 - 8 Und/Caja),,
    100,CN00498,CAT13628,12.4-28/13.6-28 (Valv TR218A - 5 Und/Caja),Test,Prov
    101,CN00508,CV1424,13.00-24/14.00-24 (Valv TR220A - 3 Und/Caja),,
    eos

    file = Tempfile.new('new_users.csv')
    file.write(csv_rows)
    file.rewind

    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @employer
    
    post "import", :file => Rack::Test::UploadedFile.new(file, 'text/csv'),:service_type_ids => [1,2,3]

    mst = MaterialServiceType.where("material_id = 100 and service_type_id = 1").first
    
    assert mst.material.name == "12.4-28/13.6-28 (Valv TR218A - 5 Und/Caja)" 
    assert mst.service_type.id = 1
    assert_redirected_to materials_path
  end
end