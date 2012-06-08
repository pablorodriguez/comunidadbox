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

class ActionController::TestCase
	include Devise::TestHelpers

  def create_all_default_data

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
  end
end