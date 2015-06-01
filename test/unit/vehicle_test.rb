require 'test_helper'

class VehicleTest < ActiveSupport::TestCase
  
  setup do
    Address.any_instance.stubs(:geocode).returns([1,1]) 
    create_all_default_data
    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
    @pablo =  create(:pablo_rodriguez) 
  end

  test "validate domain format for car" do
    vehicle = build :HRJE99
    vehicle.domain = "4444"
    
    assert !vehicle.valid_domain_format?
    assert !vehicle.valid?

    vehicle.domain = "DDD333"
    assert vehicle.valid_domain_format?

    vehicle.vehicle_type ="Motorcycle"
    assert !vehicle.valid_domain_format?

    vehicle.domain = "333DDD"
    assert vehicle.valid_domain_format?    
  end

  test "update km day ago" do
    car = @pablo.cars.first
    car.kmUpdatedAt = 1.day.ago
    assert car.update_km?
  end

   test "update km month ago" do
    car = @pablo.cars.first
    car.kmUpdatedAt = 1.month.ago
    assert car.update_km?
  end

  test "not update km 1 hs ago" do
    car = @pablo.cars.first
    car.kmUpdatedAt = 1.hour.ago
    assert car.update_km? == false
  end

  test "not update km 23 hs ago" do
    car = @pablo.cars.first
    car.kmUpdatedAt = 23.hour.ago    
    assert car.update_km? == false
  end
end
