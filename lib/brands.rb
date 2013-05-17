#!/usr/bin/env ruby
require "watir-webdriver"

b = Watir::Browser.new :firefox

puts "Setting Firefox as default browser"
b.goto "http://deautos.com"

brand_select = b.select_list(:id => "VehicleBrands")
brand_select.option.wait_until_present

brands = brand_select.options

brand_id=1
brands = brands.drop(1)
puts "Get all Brands #{brands.size}"

File.open("brands.txt", 'w') do |f|
  brands.each do |br|
    f.write("#{brand_id}\t#{br.value}\t#{br.text}\n")
    brand_id+=1
  end    
end

brand_id=0
brands.each do |br|
  brand_id+=1
  puts "Brand ID: #{brand_id}: #{br.value} #{br.text}"
  brand_select.select_value(br.value)
  #brand_select.fire_event "change"
  puts "waith until brand change"

  b.driver.manage.timeouts.implicit_wait = 5
  #Watir::Wait.until { b.select_list(:id => "VehicleModels").include? '-1' }

  models = b.select_list(:id => "VehicleModels").options
  models = models.drop(1)

  puts "Got models #{models.size}"
  File.open("brands_models.txt", 'a+') do |f|
    models.each do |model|
      puts "#{br.value}\t#{br.text}\t#{model.text}"
      f.write("#{br.value}\t#{br.text}\t#{model.text}\n")
    end    
  end
end


