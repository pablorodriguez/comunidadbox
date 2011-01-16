require "watir"

puts "Setting Firefox as default browser"
Watir::Browser.default = 'firefox'
puts "Creating FF instnace"
b = Watir::Browser.new
puts "Going to http://www.framfiltros.com.ar/frmresultadosbusquedacatalogo.aspx"
b.goto "http://www.framfiltros.com.ar/frmresultadosbusquedacatalogo.aspx"

puts "Get all Brands"
brands = b.select_list(:id,"ctl00_chpResultados_cmbMarcas").getAllContents
brand_id=1

File.open("brand-fram.txt", 'w') do |f|
  brands.each do |br|
    f.write("#{brand_id}\t#{br}\n")
    brand_id+=1
  end    
end

brand_id=0
brands.each do |br|
  brand_id+=1
  puts "Brand ID: #{brand_id}: #{br}"
  b.select_list(:id,"id_marca").set(br)
  sleep 5
  models = b.select_list(:id,"id_modelo").getAllContents
  models.delete_at 0
  File.open("brand models.txt", 'a+') do |f|
    models.each do |model|
      f.write("#{brand_id}\t#{model}\n")
      puts "\t #{brand_id}\t#{model}"      
    end    
  end
end


