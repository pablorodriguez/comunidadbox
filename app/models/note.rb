class Note < ActiveRecord::Base
	belongs_to :user
	belongs_to :workorder
	belongs_to :event
	belongs_to :budget
	belongs_to :note
	belongs_to :creator,:class_name =>"User",:foreign_key=>'creator_id'	

	def self.for_user(user)
		where("user_id = ?",user.id).order("created_at desc")
	end
  
end
