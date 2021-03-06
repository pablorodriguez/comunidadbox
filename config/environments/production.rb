ComunidadBox::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  #config.action_dispatch.x_sendfile_header = "X-Sendfile"
  config.action_mailer.default_url_options = { :host => 'www.comunidadbox.com' }
  config.action_mailer.asset_host = "http://www.comunidadbox.com"

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = true

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  config.action_mailer.delivery_method = :smtp
  
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => 'comunidadbox.com',
    :user_name            => 'mail1@comunidadbox.com',
    :password             => '5624mail',
    :authentication       => 'plain',
    :enable_starttls_auto => true  
  }
  
  #config.action_mailer.smtp_settings = {
  #  :address   => "smtp.mandrillapp.com",
  #  :port      => 587, # ports 587 and 2525 are also supported with STARTTLS
  #  :enable_starttls_auto => true, # detects and uses STARTTLS
  #  :user_name => ENV['MANDRILL_USERNAME'],
  #  :password  => ENV['MANDRILL_APIKEY'], # SMTP password is any valid API key
  #  :authentication => 'login' # Mandrill supports 'plain' or 'login'
  #  :domain => 'comunidadbox.com' # your domain to identify your server when connecting
  #}

  ENV['file_path'] = '/home/deployer/apps/comunidadbox/export_files'
  ENV['image_file_path'] = '/home/deployer/apps/comunidadbox/image_files'

  config.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix => "[combox-prd] ",
      :sender_address => %{"error notifier" <notifier@comunidadbox.com>},
      :exception_recipients => %w{pablo@comunidadbox.com}
    }
end
