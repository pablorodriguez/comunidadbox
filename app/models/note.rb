class Note < ActiveRecord::Base
	attr_accessible :message, :budget_id, :workorder_id, :event_id,:note_id,:car_id,:creator_id,:receiver_id,:respond_to

	belongs_to :user
	belongs_to :car
	belongs_to :workorder
	belongs_to :event
	belongs_to :budget
	belongs_to :note
	belongs_to :alarm
	belongs_to :creator,:class_name =>"User",:foreign_key=>'creator_id'	
  belongs_to :receiver,:class_name =>"User",:foreign_key=>'receiver_id'
  belongs_to :respond_to,:class_name =>"Note",:foreign_key=>'respond_to_id'

	def self.for_user(user)
		where("user_id = ?",user.id).order("created_at desc")
	end
  
end
