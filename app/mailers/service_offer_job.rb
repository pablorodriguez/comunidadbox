class ServiceOfferJob
  @queue = :mails
  
  class << self
    def perform      
      ServiceOffer.notify      
    end
  end
end