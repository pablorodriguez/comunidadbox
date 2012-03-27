#!/usr/bin/env ruby
require "watir-webdriver"

b = Watir::Browser.new :firefox

b.goto 'http://www.paginasamarillas.com.ar/'

b.text_field(:id => 'keyword').set "Lubricentros"
b.text_field(:id => 'locality').set "Mendoza, Mendoza, Argentina"
b.button(:id => "buscar").click
