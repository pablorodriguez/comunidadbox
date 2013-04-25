class ContactJob
  @queue = :mails
  
  class << self
    def perform(id)      
      @contact = Contact.find(id)
      ContactMailer.email(@contact).deliver
    end
  end
end