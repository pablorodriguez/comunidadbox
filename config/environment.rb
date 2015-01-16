# Load the rails application
require File.expand_path('../application', __FILE__)

ENV['RECAPTCHA_PUBLIC_KEY']  = '6Ld3w8gSAAAAAIVDO16qHzYOXYldevcNh9FI33O5'
ENV['RECAPTCHA_PRIVATE_KEY'] = '6Ld3w8gSAAAAAMD1sWC0zGlRIGzUm4E_NrJHgc63'

# Initialize the rails application
ComunidadBox::Application.initialize!


require File.expand_path('../../lib/patches/abstract_mysql_adapter', __FILE__)
