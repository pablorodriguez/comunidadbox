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
  def create_all_company_data(company_id=nil)

    #create tipos de servicios
    create :oil_change,:company_id => company_id
    create :tire_change,:company_id => company_id
    create :alignment_and_balancing,:company_id => company_id
   
    #crear materiales
    create :hand_work_material,:company_id => company_id

    #create materiales para tipos de servicios
    create :hand_work_for_tire_change,:company_id => company_id
    create :hand_work_oil_change,:company_id => company_id
   
    #create brand
    create :chevrolet,:company_id => company_id
    create :vw,:company_id => company_id
    create :fiat,:company_id => company_id


    #create model
    create :suran
    create :bora
    create :astra
    create :palio

    #crear formas de pago
    create :cash,:company_id => company_id
    create :check,:company_id => company_id
    create :credit_card,:company_id => company_id
    create :debit_card,:company_id => company_id
    
  end
  def create_all_default_data
    create :mendoza
    #create roles
    create :super_admin
    create :administrator

    create :admin
    #create country and states
    #create :argentina


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

