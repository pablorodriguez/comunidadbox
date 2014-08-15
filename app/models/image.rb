class Image < ActiveRecord::Base
  attr_accessible :car_id, :company_id,:image,:remove_image
  mount_uploader :image, ImageUploader

  belongs_to :company
  belongs_to :car
end
