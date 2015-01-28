require 'test_helper'

class MotorcycleTest < ActiveSupport::TestCase
  
  setup do
    Address.any_instance.stubs(:geocode).returns([1,1]) 
    create_all_default_data
    @pablo =  create(:pablo_rodriguez) 
  end

  test "update km day ago" do
    motorcycle = @pablo.motorcycles.first
    motorcycle.kmUpdatedAt = 1.day.ago
    assert motorcycle.update_km?
  end

   test "update km month ago" do
    motorcycle = @pablo.motorcycles.first
    motorcycle.kmUpdatedAt = 1.month.ago
    assert motorcycle.update_km?
  end

  test "not update km 1 hs ago" do
    motorcycle = @pablo.motorcycles.first
    motorcycle.kmUpdatedAt = 1.hour.ago
    assert motorcycle.update_km? == false
  end

  test "not update km 23 hs ago" do
    motorcycle = @pablo.motorcycles.first
    motorcycle.kmUpdatedAt = 23.hour.ago    
    assert motorcycle.update_km? == false
  end
end
