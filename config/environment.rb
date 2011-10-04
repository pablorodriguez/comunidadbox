# Load the rails application
require File.expand_path('../application', __FILE__)

ENV['RECAPTCHA_PUBLIC_KEY']  = '6LcoZ8YSAAAAAICZ8SL5fQU1UtBTryKaGTOfqJA4 '
ENV['RECAPTCHA_PRIVATE_KEY'] = '6LcoZ8YSAAAAAOCSleWlGLVebILh0vNb3eSlmjg0 '

# Initialize the rails application
ComunidadBox::Application.initialize!
