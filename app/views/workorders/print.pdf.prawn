company = @work_order.company
car =@work_order.car
user = car.user
table_w = 380
fs=10

pdf.define_grid(:columns => 2, :rows => 1, :gutter => 30)

pdf.grid(0,0).bounding_box do
  pdf.font_size fs
  
  pdf.image "#{RAILS_ROOT}/public/images/logo_bw.png",:position =>270,:scale =>0.40
  pdf.move_down(-20)  
  pdf.text @work_order.company.name,:size => fs +4,:style =>:bold
  pdf.text "Comprobante para Administración"
  pdf.move_down(5)
  pdf.text "Servicio Nro: #{@work_order.id}",:size => fs +8,:style =>:bold
  pdf.move_down(5)
  
  pdf.text "Cliente: #{user.full_name}",:style =>:bold
  pdf.text "Teléfono: #{user.phone}" if user.phone
  pdf.text "Email: #{user.email}" if user.email
  address = user.address ? user.address.to_text : ""
  pdf.text "Dirección: #{address}"

  pdf.move_down(5)
  pdf.text "Automovil: #{car.domain}",:style =>:bold
  pdf.text "Marca: #{car.brand.name} ,Modelo: #{car.model.name.strip!} ,Año: #{car.year}"
  pdf.text "Km. Actual: #{@work_order.km}, Km. Promedio Mensual: #{car.kmAverageMonthly}"
  
  pdf.move_down(5)  
  pdf.text "Vendedor: #{@work_order.user.full_name}"
  
  pdf.text "Estado: #{Status.status(@work_order.status)},    Realizado: #{l @work_order.performed.to_date}",:style =>:bold
  pdf.text "Forma de Pago: #{@work_order.payment_method.name}"
  pdf.move_down(5)
  
  @work_order.services.each do |service|
    operario = service.operator ? "Operario: #{service.operator.full_name} \n" :""
  
  	data =[[
  			"Servicio: #{service.service_type.name}\n Estado: #{Status.status service.status}",
  			"#{operario} Sub Total:  #{number_to_currency(service.total_price)}"
  			]]
    
    if service.car_service_offer
      cso =[
       "Oferta de Servicio: #{service.car_service_offer.service_offer.company.name}, #{service.car_service_offer.service_offer.title}",
       "Precio:  #{number_to_currency(service.car_service_offer.service_offer.final_price)}"
       ]
      data << cso  
    end			
  	
  	pdf.table data,:width =>table_w,
  		:border_width =>0,
  		:font_size => fs,
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
  		:width => table_w,
  		:font_size => fs,
  		:border_style =>:grid,
  		:row_colors =>["FFFFFF","DDDDDD"],
  		:headers =>["Material","Cantidad","Precio","Total"],
  		:align =>{0=>:left,1=>:right,2=>:right,3=>:right}
  	pdf.move_down(10)
  	
  	unless service.comment.empty?
  	 pdf.text "Comentario: #{service.comment}",:size=>fs
  	end
  	  
  	
  end
  pdf.move_down(5)
  total =[[    
  		"Total: #{number_to_currency(@work_order.total_price)}"
  		]]
  		
  pdf.table total,:width =>table_w,
  		:border_width =>0,
  		:font_size => fs +2,
  		:style => :bold,
  		:align => {0=>:right}
end		







pdf.grid(0,1).bounding_box do
 
 pdf.font_size fs
  
  pdf.image "#{RAILS_ROOT}/public/images/logo_bw.png",:position =>270,:scale =>0.40
  pdf.move_down(-20)    
  pdf.text @work_order.company.name,:size => fs +4,:style =>:bold
  pdf.text "Comprobante para Playa Servicios"
  pdf.move_down(5)
  pdf.text "Servicio Nro: #{@work_order.id}",:size => fs +8,:style =>:bold
  pdf.move_down(5)
  
  pdf.text "Cliente: #{user.full_name}",:style =>:bold
  pdf.text " "
  pdf.text " "
  pdf.text " "
  pdf.move_down(5)
  pdf.text "Automovil: #{car.domain}",:style =>:bold
  pdf.text "Marca: #{car.brand.name} ,Modelo: #{car.model.name.strip!} ,Año: #{car.year}"
  pdf.text "Km. Actual: #{@work_order.km}, Km. Promedio Mensual: #{car.kmAverageMonthly}"
  
  pdf.move_down(5)  
  pdf.text "Vendedor: #{@work_order.user.full_name}"
  
  pdf.text "Estado: #{Status.status(@work_order.status)}, Realizado: #{l @work_order.performed.to_date}",:style =>:bold
  pdf.text " "
  pdf.move_down(5)
  
  @work_order.services.each do |service|
    operario = service.operator ? "Operario: #{service.operator.full_name} " : ""
    
    data =[[
        "Servicio: #{service.service_type.name}\n Estado: #{Status.status service.status}",
        operario
        ]]
    
    if service.car_service_offer
      cso =[
       "Oferta de Servicio: #{service.car_service_offer.service_offer.company.name}, #{service.car_service_offer.service_offer.title}",
       ""
       ]
      data << cso  
    end     
        
    pdf.table data,:width =>table_w,
      :border_width =>0,
      :font_size => fs,
      :align => {0=>:left,1=>:right}
    pdf.move_down(5)
    
    materials = service.material_services.map do |ms|
      mat = ms.material_service_type ? ms.material_service_type.material.detail : ms.material 
      [
        mat,
        ms.amount
      ] 
    end
    
    pdf.table materials,
      :width => table_w,
      :font_size => fs,
      :border_style =>:grid,
      :row_colors =>["FFFFFF","DDDDDD"],
      :headers =>["Material","Cantidad"],
      :align =>{0=>:left,1=>:right,2=>:right,3=>:right}
    pdf.move_down(10)
    
    unless service.comment.empty?
     pdf.text "Comentario: #{service.comment}",:size=>fs
    end
      
    
  end
 
end   
