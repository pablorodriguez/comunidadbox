  
require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do    
    create_all_default_data
    @user =  create(:pablo_rodriguez)
    @employer =  create(:gustavo_de_antonio)
    create_all_company_data @employer.company_id
  end

  test "send message company" do
    sign_in @employer    
    @request.cookies["company_id"]= @employer.company.id.to_s
    xhr :post,:create,:message => {:user_id => @employer.to_param,:message => "nuevo mensaje"}
    assert_response :success
    assert_template "create" 
  end

  test "send no message company" do
    sign_in @employer    
    @request.cookies["company_id"]= @employer.company.id.to_s
    xhr :post,:create,:message => {:user_id => @employer.to_param}
    assert_response :success  
    assert_template "error"
  end
end