class Message < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :alarm
  belongs_to :workorder
  belongs_to :budget
  belongs_to :user
  belongs_to :event
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'

  scope :for_user,lambda { |user| where("receiver_id = ?",user.id)}
  scope :unread, where(:read => false)
  

  def email
    MessageMailer.deliver_mail(id)
  end

end
