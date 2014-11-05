require 'test_helper'

class ServiceOfferTest < ActiveSupport::TestCase

  setup do
    create_all_default_data            
    @employer =  create(:gustavo_de_antonio)    
    create_all_company_data @employer.company_id 
    @pablo = create(:pablo_rodriguez)
    @user = create(:imr_admin)
    @so = create(:so_ad_1_day,:company => @employer.company)
    @so1 = create(:so_ad_1_day,:company => @employer.company, :cars => @pablo.cars)
  end

  test "three advertisements in same days" do 
    
  end

  test "advertisement more than 3 same day" do
  end

end

