# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run ComunidadBox::Application


use Rails::Rack::LogTailer
use Rails::Rack::Static
run Rack::URLMap.new(
  "/" => ActionController::Dispatcher.new,
  "/resque" => Resque::Server.new
)