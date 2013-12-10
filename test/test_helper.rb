ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'


class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all  

  # Add more helper methods to be used by all tests here...

end

module ComunidadBox::TestHelpers
  def create_all_default_data
    #create country and states
    #create :argentina
    create :mendoza

    #create brand
    create :chevrolet
    create :vw

    #create model
    create :suran
    create :astra

    #crear formas de pago
    create :cash
    create :check
    create :credit_card
    create :debit_card

    #create tipos de servicios
    create :oil_change
    create :tire_change
    create :alignment_and_balancing

    #crear materiales
    create :hand_work_material

    #create materiales para tipos de servicios
    create :hand_work_for_tire_change
    create :hand_work_oil_change
    
    #create roles
    create :administrator
  end
end

class ActionDispatch::Routing::RouteSet
  def url_for_with_locale_fix(options)
    url_for_without_locale_fix({:locale => I18n.default_locale}.merge(options))
  end

  alias_method_chain :url_for, :locale_fix
end

class ActionController::TestCase
  include Devise::TestHelpers
  include ComunidadBox::TestHelpers
end

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join("test", "vcr_cassettes")
  c.hook_into :webmock
  c.ignore_localhost = true
  c.debug_logger = File.open("vcr.log", 'w')
  c.allow_http_connections_when_no_cassette = true
end

require "mocha/setup"

class ActiveSupport::TestCase  
  include ComunidadBox::TestHelpers
end

