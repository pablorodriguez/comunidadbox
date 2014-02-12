class AdvertisementDay < ActiveRecord::Base
  attr_accessible :advertisement_id, :published_on

  belongs_to :advertisement
end
