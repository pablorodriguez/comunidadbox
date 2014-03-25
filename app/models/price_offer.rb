class PriceOffer < ActiveRecord::Base
  belongs_to :workorder
  belongs_to :user
  attr_accessible :confirmed, :price

	validates_presence_of :price, :message => I18n.t(".must_enter_price")

  def self.find_by_user_and_workorder(user, workorder)
  	priceOffer = PriceOffer.where("user_id = ? and workorder_id = ?", user, workorder).first
  	
  	if priceOffer.blank?
  		priceOffer = PriceOffer.new 
  		priceOffer.workorder = workorder
  		priceOffer.user = user
  	end

  	priceOffer
  end
end
