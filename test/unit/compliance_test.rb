require 'test_helper'

class ComplianceTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @model = EmployeeSearch.new
  end

  test "model_name exposes singular and human name" do
    assert_equal "employee_search", @model.class.model_name.singular
    assert_equal "Employee search", @model.class.model_name.human
  end

  test "model_name.human uses I18n" do
    begin
      I18n.backend.store_translations :en,:activemodel => { :models => { :employee_search => "My Employee Search" } }
      #assert_equal "My Employee Search", @model.class.model_name.human
    ensure
      I18n.reload!
    end
  end


end