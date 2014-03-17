class ExportsController < ApplicationController
 	layout "application" #, :except => [:add_service_type,:remove_service_type,:search]
  #skip_before_filter :authenticate_user!, :only => [:index,:show,:all,:search,:search_distance]
  #authorize_resource

	def index
		@export = current_user.export
#		root_export_directory = Rails.root.to_s + '/export/'
#		my_file_path = root_export_directory + '/12/'
#
#		unless File.exist?(File.dirname(my_file_path))
#			FileUtils.mkdir_p(File.dirname(my_file_path))
#		end
#		Workorder.to_csv(my_file_path + "workorders.csv", 12)
	end

	def show
	end

	def new
		export = current_user.export
		export.destroy if export.present?
		export = Export.new
		export.user = current_user
		export.company = current_user.company_active
		export.save

		redirect_to exports_path
	end
end
