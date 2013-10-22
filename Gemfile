
if RUBY_VERSION =~ /1.9/
    Encoding.default_external = Encoding::UTF_8
    Encoding.default_internal = Encoding::UTF_8
end


source 'http://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'mysql'
gem 'mysql2','0.3.10'
gem "haml"
gem "will_paginate", "~> 3.0.pre2"
gem "foreigner"
#config.gem "declarative_authorization", :source =>"http://gemcutter.org"
gem "chronic"
gem "packet"
gem 'prawn'
gem 'prawnto'
gem "geokit"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platform => :ruby
  # gem 'twitter-bootstrap-rails'
  # gem 'bootstrap-sass'
  gem 'uglifier', '>= 1.0.3'  
end

group :development, :test do
  #gem 'turn'
  gem "timecop"
  gem "better_errors"
end

gem "mocha",:require => false


# GEOLOCALIZACION Y MAPAS
gem 'geocoder'
gem 'gmaps4rails'

gem "devise"
gem "devise-encryptable"
gem 'jquery-rails'

#gem 'delayed_job'
gem 'resque', :require =>"resque/server"
gem 'capistrano-resque'
#gem 'resque-scheduler'
gem 'rufus-scheduler'
gem 'factory_girl_rails',"~> 3.0"
gem 'cancan'
gem 'jbuilder'
#gem 'omniauth-facebook'
#gem 'rails3-jquery-autocomplete'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Use unicorn as the web server
gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

gem "simple_form"

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'
gem 'debugger', group: [:development,:test]



# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
#gem 'rake', '0.8.7'
gem 'attribute_normalizer'
gem 'recaptcha', :require => 'recaptcha/rails'
#gem "exception_notification", :git => "https://github.com/sickill/exception_notification.git", :require => 'exception_notifier'
#gem "breadcrumbs_on_rails"
