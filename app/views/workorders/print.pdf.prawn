company = @work_order.company
vehicle =@work_order.vehicle
user = vehicle.user
table_w = 390
fs=9

logo_path = company.get_logo_url ? "#{::Rails.root.join('public')}#{company.get_logo_url}" : ""

pdf.define_grid(:columns => 2, :rows => 1, :gutter => 30)

pdf.grid(0,0).bounding_box do
  pdf.font_size fs
  pdf.move_up(15)

  pdf.image "#{::Rails.root.join('public','images','logo_n.png')}",:at=>[290,570],:scale =>0.40
  pdf.image "#{logo_path}",:at=>[10,570],:scale =>0.40 unless logo_path.empty?

  pdf.move_down(40)
  pdf.text @work_order.company.name
  pdf.text "Comprobante para Administración"

  pdf.move_up(27)
  pdf.text "Servicio Nro: #{@work_order.id}",:size => fs +8,:style =>:bold,:align=>:right

  pdf.move_down(10)

  address = user.address ? user.address.to_text : ""
  company_name = user.company_name ? "Razon Social: #{user.company_name}" : ""

  data_info = [
    ["Cliente: #{user.full_name}","Automovil: #{vehicle.domain}"],
    ["Teléfono: #{user.phone}","#{vehicle.brand.name}, #{vehicle.model.name}, #{vehicle.year}"],
    ["Email: #{user.email}","Km. Actual: #{@work_order.km}"],
    [company_name,"Km. Promedio Mensual: #{vehicle.kmAverageMonthly}"]
  ]

  unless vehicle.chassis.try(:empty?)
    data_info.insert(2,["","Chassis: #{vehicle.chassis}"])
  end

  data_info << ["CUIT:#{user.cuit}","#{@work_order.status_name}"] if user.cuit
  data_info << [address,"#{@work_order.payment_method_name}"]
  data_info << ["Vendedor: #{@work_order.user.full_name}",""]
  data_info << ["Realizado: #{l @work_order.performed.to_date}",""]


  pdf.table data_info do
    cells.padding=0
    cells.borders=[]
    column(1).style{|c| c.align = :right}
    columns(0..1).width = 197
    [0,1].each{|i| column(i).style { |c| c.border_width = 0 }}
    row(4).column(0).font_style = :bold if user.cuit
  end

  pdf.move_down 3

  column_widths = [242,38,57,58]
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
  			"#{service.service_type.name} [#{service.status.name}]",
  			"#{operario}"
  			]]

    if service.vehicle_service_offer
      cso =[
       "Oferta de Servicio: #{service.vehicle_service_offer.service_offer.company.name}, #{service.vehicle_service_offer.service_offer.title}",
       "Precio:  #{number_to_currency(service.vehicle_service_offer.service_offer.final_price)}"
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
      mat = ms.material_service_type ? "[#{ms.material_service_type.material.prov_code}] #{ms.material_service_type.material.detail}" : ms.material
  		[
  			mat,
  			ms.amount,
  			number_to_currency(ms.price),
  			number_to_currency(ms.total_price)
  		]
  	end

    if materials.size > 0
      materials += [[
        "","","Sub Total","#{number_to_currency(service.total_price)}"
      ]]


    	pdf.table materials do
        cells.padding= [1,5]
        [1,2,3].each{|c1|column(c1).style{|c| c.align = :right}}
        column_widths.each_index{|i| column(i).width = column_widths[i] }
      end
    end

  	pdf.move_down(10)

  	if service.comment
  	 pdf.text "Comentario: #{service.comment}",:size=>fs
  	end
  end

  #pdf.move_down(3)
  pdf.text "Total: #{number_to_currency(@work_order.total_price)}",:align =>:right,:style =>:bold
  pdf.text "Hora de Entrega: #{l(@work_order.deliver,:format => :short)}",:size => fs +4,:style =>:bold,:align=>:left if @work_order.deliver

end






pdf.grid(0,1).bounding_box do

  pdf.font_size fs
  pdf.move_up(15)

  pdf.image "#{::Rails.root.join('public','images','logo_n.png')}",:at=>[290,570],:scale =>0.40
  pdf.image "#{logo_path}",:at=>[10,570],:scale =>0.40 unless logo_path.empty?

  pdf.move_down(40)
  pdf.text @work_order.company.name
  pdf.text "Comprobante para Playa Servicios"
  pdf.move_up(27)
  pdf.text "Servicio Nro: #{@work_order.id}",:size => fs +8,:style =>:bold,:align=>:right

  pdf.move_down(10)
  data_info = [[
    "Cliente: #{user.full_name} ",
    "Automovil: #{vehicle.domain} \n #{vehicle.brand.name}, #{vehicle.model.name}, #{vehicle.year} \n Km. Actual: #{@work_order.km} \n Km. Promedio Mensual: #{vehicle.kmAverageMonthly}"
    ]]

  pdf.table data_info do
    cells.padding=0
    cells.borders=[]
    columns(0..1).width = 197
    column(1).style{|c| c.align = :right}
    [0,1].each{|i| column(i).style { |c| c.border_width = 0 }}
  end

  data_info = [[
    "Vendedor: #{@work_order.user.full_name}",
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
        "#{service.service_type.name} [#{service.status.name}]",
        "#{operario}"
      ]]

    if service.vehicle_service_offer
      cso =[
       "Oferta de Servicio: #{service.vehicle_service_offer.service_offer.company.name}, #{service.vehicle_service_offer.service_offer.title}",
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
      mat = ms.material_service_type ? "[#{ms.material_service_type.material.prov_code}] #{ms.material_service_type.material.detail}" : ms.material
      [
        mat,
        ms.amount
      ]
    end

    column_widths = [360,30]
    if materials.size > 0
      pdf.table materials do
        column_widths.each_index{|i| column(i).width = column_widths[i] }
        column(1).style{|c| c.align = :right}
        cells.padding= [1,5]
      end
    end

    pdf.move_down(10)

    unless service.comment
     pdf.text "Comentario: #{service.comment}",:size=>fs
    end

  end
  pdf.text "Hora de Entrega: #{l(@work_order.deliver,:format => :short)}",:size => fs +4,:style =>:bold,:align=>:left if @work_order.deliver

end
