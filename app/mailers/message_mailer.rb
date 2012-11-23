class MessageMailer < ActionMailer::Base
  default from: "from@example.com"

  def email(message)
    @message = message
    mail(:to => @message.receiver.email,:subject => "nuevo mensaje desde Comunidad Box")
  end
end
