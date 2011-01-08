company = @work_order.company
car =@work_order.car
user = car.user

pdf.text "Comunidad Box", :size=>25,:style =>:bold,:align =>:center
pdf.text "Estimado #{user.full_name}"
pdf.text "Muchas gracias por usar Comunidad Box, uds a realizado una servicio en nuestra red de prestadores"
pdf.move_down(15)
pdf.text "Prestador de Servicio: #{@work_order.company.name}", :size=>20,:style =>:bold
pdf.text "Servicio Nro:#{@work_order.id}, Estado :#{@work_order.status}, Realizado: #{l @work_order.created_at.to_date}", :size=>14,:style =>:bold

address = company.address
pdf.text "Pais: #{address.state.country.name}, Provincia: #{address.state.name}, Ciudad: #{address.city}"
pdf.text "Dirección: #{address.street}, #{address.zip}, #{address.name}"
pdf.text "Operario: #{@work_order.user.full_name}"
pdf.move_down(20)
pdf.text "Automovil: #{car.domain}",:size=>20,:style =>:bold
pdf.text "Marca: #{car.brand.name} ,Modelo: #{car.model.name} ,Año: #{car.year} ,Km: #{car.km}"
pdf.text "Usuario: #{user.full_name}" 
pdf.move_down(15)

@work_order.services.each do |service|
	
	data =[[
			"Servicio: #{service.service_type.name}, Estado: #{service.status}",
			"Total:  #{number_to_currency(service.total_price)}"
			]]
	pdf.table data,:width =>500,
		:border_width =>0,
		:align => {0=>:left,1=>:right}
	pdf.move_down(5)
	
	materials = service.material_services.map do |ms|
		mat = ms.material_service_type ? ms.material_service_type.material.detail : ms.material 
		[
			mat,
			ms.amount,
			number_to_currency(ms.price),
			number_to_currency(ms.total_price)			
		]	
	end
	pdf.table materials,
		:width => 500,
		:border_style =>:grid,
		:row_colors =>["FFFFFF","DDDDDD"],
		:headers =>["Material","Cantidad","Precio","Total"],
		:align =>{0=>:left,1=>:right,2=>:right,3=>:right}
	pdf.move_down(10)
end
pdf.move_down(10)
total =[[
		"Total: #{number_to_currency(@work_order.total_price)}"
		]]
pdf.table total,:width =>500,
		:border_width =>0,
		:font_size => 15,
		:style => :bold,
		:align => {0=>:right}
		
