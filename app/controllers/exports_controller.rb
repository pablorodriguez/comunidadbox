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

	def new
		export = current_user.export
		export.destroy if export.present?
		export = Export.new
		export.user = current_user
		export.company = current_user.company_active
		export.save

		redirect_to exports_path
	end

	def download
		file = ExportItem.get_file(params['id'])
		if file.present?
			respond_to do |format|
      	format.html { send_file file}
  	  end
		else
			flash[:alert] = t("file_not_found")
   		redirect_to exports_path
		end
	end

	def run
		export = current_user.export
		puts 'cambiando estado a Running'
		export.status = Status::RUNNING
		export.save
		puts 'guardado estado = running'

		puts 'generando archivos csv'
		export.run_export
		puts 'archivos csv generados'


		puts 'cambiando estado a Running'
    export.status = Status::DONE
		export.save
		puts 'guardado estado = running'


		redirect_to exports_path
#		@export.export_items.each |item| do
#			if item.workorders?
#				Workorder.to_csv(item.file_path + item.file_name, @export.company.id)
#			elsif item.customers?
#			elsif item.budgets?
#			end
#		end
	end
end
