#!/usr/bin/env ruby

require "watir"

puts "Setting Firefox as default browser"
Watir::Browser.default = 'firefox'
puts "Creating FF instnace"
b = Watir::Browser.new
puts "Going to http://www.framfiltros.com.ar"
b.goto "http://www.framfiltros.com.ar/frmresultadosbusquedacatalogo.aspx"

puts "Get all Filters"
categories = b.select_list(:id,"ctl00_chpResultados_cmbCategorias").getAllContents
brands = b.select_list(:id,"ctl00_chpResultados_cmbMarcas").getAllContents

File.open("brand-model-fram.txt", 'w') do |f|
  brands.each do |br|
    b.select_list(:id,"ctl00_chpResultados_cmbMarcas").set(br)
    sleep 5
    all_models = b.select_list(:id,"ctl00_chpResultados_cmbModelos").getAllContents
    puts "Brand :#{br}"
    all_models.each do |m|
      puts "   Model: #{m}"
      f.write("#{br}\t#{m}\n")
    end
    
  end    
end

