class PaymentMethod < ActiveRecord::Base
  attr_accessible :name
  def self.cash
    @cash ||= PaymentMethod.find(1)
  end

  def native_name
    I18n.t(name)
  end

  def self.default_payment
    1
  end
  

end
