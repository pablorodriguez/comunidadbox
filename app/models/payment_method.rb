class PaymentMethod < ActiveRecord::Base

  def self.cash
    @cash ||= PaymentMethod.find(1)
  end
end
