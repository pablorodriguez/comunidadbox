  
require 'test_helper'

class NotesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do    
    create_all_default_data    
    @user =  create(:pablo_rodriguez)
    @employer =  create(:gustavo_de_antonio)

  end

end