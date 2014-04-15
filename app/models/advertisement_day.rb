class AdvertisementDay < ActiveRecord::Base
  attr_accessible :advertisement_id, :published_on
  default_scope order('advertisement_days.published_on')
  
  belongs_to :advertisement
end
