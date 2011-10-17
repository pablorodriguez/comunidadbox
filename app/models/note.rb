class Note < ActiveRecord::Base
	belongs_to :user
	belongs_to :workorder
	belongs_to :note
	belongs_to :creator,:class_name =>"User",:foreign_key=>'creator_id'	
end
