class PaymentMethod < ActiveRecord::Base
  attr_accessible :name,:company_id,:active
  default_scope order('name')
  belongs_to :company
  scope :active, where("active = 1")
  
  def self.cash
    @cash ||= PaymentMethod.find(1)
  end

  def self.default_payment
    1
  end
end
