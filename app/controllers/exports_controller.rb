class ExportsController < ApplicationController
 	layout "application" #, :except => [:add_service_type,:remove_service_type,:search]
  #skip_before_filter :authenticate_user!, :only => [:index,:show,:all,:search,:search_distance]
  #authorize_resource

	def index
		@export = current_user.export
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


		puts 'cambiando estado a Done'
    export.status = Status::DONE
		export.save
		puts 'guardado estado = Done'

		redirect_to exports_path
	end
end
