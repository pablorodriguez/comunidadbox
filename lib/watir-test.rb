#require 'watir'
require 'watir-webdriver'

browser = Watir::Browser.new :chrome
browser.goto 'http://bit.ly/watir-example'