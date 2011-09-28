company = @work_order.company
car =@work_order.car
user = car.user
table_w = 390
fs=9

pdf.define_grid(:columns => 2, :rows => 1, :gutter => 30)

pdf.grid(0,0).bounding_box do
  pdf.font_size fs
  pdf.move_up(15)
  pdf.image "#{RAILS_ROOT}/public/images/logo_bw.png",:at=>[290,570],:scale =>0.40
  pdf.text @work_order.company.name,:size => fs +4,:style =>:bold
  pdf.text "Comprobante para Administración"
  pdf.move_down(5)
  pdf.text "Servicio Nro: #{@work_order.id}",:size => fs +8,:style =>:bold  
  
  data_info = [[
    "Cliente: #{user.full_name}\nTeléfono: #{user.phone}\nEmail: #{user.email}\n#{user.address.to_text}",
    "Automovil: #{car.domain}\n#{car.brand.name}, #{car.model.name.strip!}, #{car.year}\nKm. Actual: #{@work_order.km}\nKm. Promedio Mensual: #{car.kmAverageMonthly}"
    ]]

  pdf.table data_info do
    cells.padding=0
    cells.borders=[]
    column(1).style{|c| c.align = :right}
    [0,1].each{|i| column(i).style { |c| c.border_width = 0 }}
  end

  data_info = [[
    "Vendedor: #{@work_order.user.full_name} [#{Status.status(@work_order.status)}]",
    "Realizado: #{l @work_order.performed.to_date} [#{@work_order.payment_method.name}]"
    ]]
  
  pdf.table data_info do
    cells.padding=0
    cells.borders=[]
    columns(0..1).width = 197    
    column(1).style{|c| c.align = :right}
  end
  pdf.move_down 3
  
  column_widths = [222,58,57,58]
  # materials  = [["Material","Cantidad","Precio","Total"]]
  # pdf.table materials do      
  #   cells.padding=2       
  #   row(0).font_style=:bold
  #   [1,2,3].each{|c1|column(c1).style{|c| c.align = :right}}
  #   column_widths.each_index{|i| column(i).width = column_widths[i] }
  # end
  # pdf.move_down 3

  @work_order.services.each do |service|
    operario = service.operator ? "Operario: #{service.operator.full_name} \n" :""
  
  	data =[[
  			"#{service.service_type.name} [#{Status.status service.status}]",
  			"#{operario}"
  			]]
    
    if service.car_service_offer
      cso =[
       "Oferta de Servicio: #{service.car_service_offer.service_offer.company.name}, #{service.car_service_offer.service_offer.title}",
       "Precio:  #{number_to_currency(service.car_service_offer.service_offer.final_price)}"
       ]
      data << cso  
    end			
  	
    pdf.table data do            
      cells.padding=0      
      columns(0..1).width = 197 
      cells.borders=[]
      column(1).style{|c| c.align = :right}      
    end
    pdf.move_down 2

  	materials =  service.material_services.map do |ms|
  		mat = ms.material_service_type ? ms.material_service_type.material.detail : ms.material 
  		[
  			mat,
  			ms.amount,
  			number_to_currency(ms.price),
  			number_to_currency(ms.total_price)			
  		]	
  	end

    materials += [[
      "","","Sub Total","#{number_to_currency(service.total_price)}"
    ]]
  	
   
  	pdf.table materials do      
      cells.padding= [1,5]       
      [1,2,3].each{|c1|column(c1).style{|c| c.align = :right}}
      column_widths.each_index{|i| column(i).width = column_widths[i] }
    end
    

  	pdf.move_down(10)
  	
  	unless service.comment.empty?
  	 pdf.text "Comentario: #{service.comment}",:size=>fs
  	end
  end

  #pdf.move_down(3)
  pdf.text "Total: #{number_to_currency(@work_order.total_price)}",:align =>:right,:style =>:bold

end		







pdf.grid(0,1).bounding_box do
 
  pdf.font_size fs
  pdf.move_up(15)
  pdf.image "#{RAILS_ROOT}/public/images/logo_bw.png",:at=>[290,570],:scale =>0.40

  pdf.text @work_order.company.name,:size => fs +4,:style =>:bold
  pdf.text "Comprobante para Playa Servicios"
  pdf.move_down(5)
  pdf.text "Servicio Nro: #{@work_order.id}",:size => fs +8,:style =>:bold
  
  data_info = [[
    "Cliente: #{user.full_name} ",
    "Automovil: #{car.domain} \n #{car.brand.name}, #{car.model.name.strip!}, #{car.year} \n Km. Actual: #{@work_order.km} \n Km. Promedio Mensual: #{car.kmAverageMonthly}"
    ]]

  pdf.table data_info do
    cells.padding=0
    cells.borders=[]         
    columns(0..1).width = 197  
    column(1).style{|c| c.align = :right}
    [0,1].each{|i| column(i).style { |c| c.border_width = 0 }}
  end

  data_info = [[
    "Vendedor: #{@work_order.user.full_name} [#{Status.status(@work_order.status)}]",
    "Realizado: #{l @work_order.performed.to_date} [#{@work_order.payment_method.name}]"
    ]]
  
  pdf.table data_info do
    cells.padding=0
    cells.borders=[]
    columns(0..1).width = 197    
    column(1).style{|c| c.align = :right}
  end
  pdf.move_down 3
  
  @work_order.services.each do |service|
    operario = service.operator ? "Operario: #{service.operator.full_name} " : ""
    
    data =[[
        "#{service.service_type.name} [#{Status.status service.status}]",
        "#{operario}"
      ]]
    
    if service.car_service_offer
      cso =[
       "Oferta de Servicio: #{service.car_service_offer.service_offer.company.name}, #{service.car_service_offer.service_offer.title}",
       ""
       ]
      data << cso  
    end     
      
    pdf.table data do            
      cells.padding=0      
      columns(0..1).width = 197 
      cells.borders=[]
      column(1).style{|c| c.align = :right}      
    end
    pdf.move_down 2
    
    materials = service.material_services.map do |ms|
      mat = ms.material_service_type ? ms.material_service_type.material.detail : ms.material 
      [
        mat,
        ms.amount
      ] 
    end
    
    column_widths = [293,97]
    pdf.table materials do
      column_widths.each_index{|i| column(i).width = column_widths[i] }
      column(1).style{|c| c.align = :right}      
      cells.padding= [1,5]      
    end

    pdf.move_down(10)
    
    unless service.comment.empty?
     pdf.text "Comentario: #{service.comment}",:size=>fs
    end
      
    
  end
 
end   
