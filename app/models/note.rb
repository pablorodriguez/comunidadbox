# encoding: utf-8
class Note < ActiveRecord::Base
	attr_accessible :message, :budget_id, :workorder_id, :event_id,:note_id,:vehicle_id,:creator_id,:receiver_id,:respond_to,:user_id

	belongs_to :user
	belongs_to :company
	belongs_to :vehicle
	belongs_to :workorder
	belongs_to :event
	belongs_to :budget
	belongs_to :note
	belongs_to :alarm
	belongs_to :creator,:class_name =>"User",:foreign_key=>'creator_id'
  belongs_to :receiver,:class_name =>"User",:foreign_key=>'receiver_id'
  belongs_to :respond_to,:class_name =>"Note",:foreign_key=>'respond_to_id'

  validates :message,:presence => true
 	before_save :set_company_id

 	def set_company_id
 		self.company_id = self.creator.company_id if creator.company_id
 	end

	def self.for_user(user)
		where("user_id = ?",user.id).order("created_at desc")
	end

	def self.for_event_end_user(event,user)
    Note.where("event_id = ? && company_id IN (?)",event.id,user.get_companies_ids)
  end

end
