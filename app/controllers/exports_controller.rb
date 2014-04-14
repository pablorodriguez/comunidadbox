class ExportsController < ApplicationController
 	layout "application" #, :except => [:add_service_type,:remove_service_type,:search]
  #skip_before_filter :authenticate_user!, :only => [:index,:show,:all,:search,:search_distance]
  #authorize_resource

	def index
		@export = current_user.export
	end

	def new		
		export = Export.create_for_user current_user
		
		#Correr el export en el controller
		#export.run_export	

		#Esto si queres que el export lo corra en background, tenes que tener a REDIS up y RESQUE
		Resque.enqueue ExportJob,export.id
		redirect_to exports_path
	end

	def download

		#esto de alguna forma deberia estar en abilities?----
		if !Export.can_download? current_user, params['id']
			flash[:alert] = t("Error")
			redirect_to exports_path
			return
		end
		#----------------------------

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
		logger.debug 'generando archivos csv'

		#Correr el export en el controller
		export.run_export		

		#Esto si queres que el export lo corra en background, tenes que tener a REDIS up y RESQUE
		#Resque.enqueue ExportJob,export.id
		redirect_to exports_path
	end
end
