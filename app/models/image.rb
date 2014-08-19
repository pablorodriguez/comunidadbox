class Image < ActiveRecord::Base
  attr_accessible :image,:remove_image
  mount_uploader :image, ImageUploader
  belongs_to :imageable, polymorphic: true

end
