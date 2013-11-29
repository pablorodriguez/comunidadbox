company = @work_order.company
car =@work_order.car
user = car.user
fs=14

pdf.move_down(25)
pdf.text "Servicio Nro: #{@work_order.id}",:size=>fs+4,:style =>:bold
pdf.image "#{::Rails.root.join('public','images','logo_n.png')}",:at=>[430,800],:scale =>0.60

pdf.move_down(45)
pdf.text "Estimado #{user.full_name}",:size=>fs,:style =>:bold
pdf.text "Muchas gracias por usar Comunidad Box, Ud. ha realizado un servicio en nuestra red de prestadores",:size=>fs
pdf.move_down(5)

if @work_order.company
  pdf.text "Prestador de Servicio: #{@work_order.company.name}", :size=>fs,:style =>:bold
  address = company.address
  pdf.text "Pais: #{address.state.country.name}, Provincia: #{address.state.name}, Ciudad: #{address.city}",:size=>fs
  pdf.text "Dirección: #{address.street}, #{address.zip}, Tel: #{company.phone}",:size=>fs
end

if (@work_order.company_info && !(@work_order.company_info.empty?))
  pdf.text "Prestador de Servicio: #{@work_order.company_info}", :size=>fs,:style =>:bold
end


pdf.text "Estado: #{Status.status(@work_order.status)}, Realizado: #{l @work_order.performed.to_date}", :size=>fs,:style =>:bold
pdf.text "Vendedor: #{@work_order.user.full_name}",:size=>fs
pdf.text "Forma de Pago: #{@work_order.payment_method.name}",:size=>fs
pdf.move_down(5)
pdf.text "Automovil: #{car.domain}",:size=>20,:style =>:bold,:size=>fs
pdf.text "Marca: #{car.brand.name} ,Modelo: #{car.model.name.strip!} ,Año: #{car.year} ,Km: #{@work_order.km}, Km. Actual: #{car.km}",:size=>fs
pdf.move_down(5)

@work_order.services.each do |service|
	
	operator = service.operator ? "Operario: #{service.operator.full_name} \n" : ""
	data =[[
			"Servicio: #{service.service_type.name} \n Estado: #{Status.status service.status}",
			"#{operator} Total:  #{number_to_currency(service.total_price)}"
			]]
  
	if service.car_service_offer
		cso =[
		 "Oferta de Servicio: #{service.car_service_offer.service_offer.company.name}, #{service.car_service_offer.service_offer.title}",
		 "Total:  #{number_to_currency(service.car_service_offer.service_offer.final_price)}"
		 ]
		data << cso  
	end			
			
	pdf.table data,:cell_style => {:size => fs} do		
		width = 540
		column(1).style{|c| c.align = :right}
		[0,1].each do |i|
			column(i).style { |c| c.border_width = 0 }
			column(i).width = 270
		end
	end
		
	pdf.move_down(5)

	column_widths = [330,70,70,70]

	materials = [["Material","Cantidad","Precio","Total"]]
	materials += service.material_services.map do |ms|
		mat = ms.material_service_type ? ms.material_service_type.material.detail : ms.material 
		[
			ms.material,
			ms.amount,
			number_to_currency(ms.price),
			number_to_currency(ms.total_price)			
		]	
	end
	
	pdf.table materials, :cell_style => {:size => fs} do
		width = 540		
		[1,2,3].each{|c1| column(c1).style{|c| c.align = :right} }
    column_widths.each_index{|i| column(i).width = column_widths[i] }
	end		
		
	pdf.move_down(10)
	
	unless service.comment
	 pdf.text "Comentarios: #{service.comment}",:size=>fs
	end
	  
	
end
pdf.move_down(5)
total =[[    
		"Total: #{number_to_currency(@work_order.total_price)}"
		]]
		
pdf.table total,:cell_style => {:size => fs},:width =>540 do
	
  column_widths.each_index{|i| column(i).width = column_widths[i] }

	column(0).style{|c| c.align = :right}
	column(0).style{|c| c.border_width = 0}	
end

