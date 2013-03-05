class Message < ActiveRecord::Base
  attr_accessible :message,:receiver_id,:message_id

  belongs_to :alarm
  belongs_to :workorder
  belongs_to :budget
  belongs_to :user
  belongs_to :event
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'
  has_many :responses,:class_name =>"Message",:foreign_key => 'message_id'
  belongs_to :respond,:class_name =>"Message",:foreign_key => 'message_id'

  scope :for,lambda { |user| where("receiver_id = ?",user.id)}
  scope :send_by,lambda { |user| where("user_id = ?",user.id)}
  scope :unread, where(:read => false)
  validates :message,:presence => true

  def email
    MessageMailer.deliver_mail(id)
  end

  def self.messages_for_user(user)    
    #ids = where("user_id = ? and message_id is not null", user.id).pluck(:message_id)
    #debugger
    # where("(user_id = :USER_ID AND message_id is null)",USER_ID: user.id)
    #where("(user_id = :USER_ID AND message_id is null) or id IN (:IDS)",USER_ID: user.id,IDS: ids).order("created_at DESC")
    where("(user_id = :USER_ID) or (receiver_id = :USER_ID)",USER_ID: user.id).order("created_at")
  end

  def self.between(user_a,user_b)
    where("(user_id = :USER_A and receiver_id = :USER_B) or (receiver_id = :USER_A and user_id = :USER_B)",USER_A: user_a.id, USER_B: user_b.id).order("created_at")
  end

  def self.for_user(user)
    #User.includes(:messages).where("(messages.user_id = :USER_ID) or (messages.receiver_id = :USER_ID)",USER_ID: user.id).order("users.last_name, users.first_name")    
    sql ="select * from users where id in(select distinct(id) from (      
      select distinct(user_id)as id from messages where receiver_id = ?
      union all
      select distinct(receiver_id)as id from messages where user_id = ?) as msgs) 
      order by last_name,first_name
    "
    User.find_by_sql([sql,user.id,user.id])

  end

end
