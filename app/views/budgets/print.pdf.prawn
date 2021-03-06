fs=12
company = @budget.creator.company
pdf.font_size fs
pdf.move_down(15)

logo_path = company.logo ? "#{::Rails.root.join('public')}#{company.get_logo_url}" : ""

pdf.image "#{::Rails.root.join('public','images','logo_n.png')}",:at=>[455,820],:scale =>0.50
pdf.image "#{logo_path}",:at=>[10,820],:scale =>0.40

pdf.move_down(30)
pdf.text "#{company.full_address}, #{company.phone}"


pdf.move_down(5)
pdf.text "Presupuesto Nro: #{@budget.nro}",:size=>fs,:size=>10,:style =>:bold
pdf.move_up(25)
pdf.text "Realizado: #{l(Date.parse(@budget.created_at.to_s))}",:align=>:right,:size=>10,:style =>:bold
pdf.text "Responsable de Venta: #{@budget.creator.full_name}",:size =>6,:align=>:right
pdf.move_down(20)

data =[
    ["Cliente","Autómovil"],
]

pdf.table data do
  row(0).font_style = :bold
  row(0).borders = [:bottom]
  row(0).border_width = 0.8
  cells.borders = [:top]
  columns(0..1).width = 277
end

brand = @vehicle.brand ? @vehicle.brand.name : ""
model = @vehicle.model ? @vehicle.model.name : ""
data=[
    ["Nombre",@client.first_name,"Marca",brand],
    ["Apellido",@client.last_name,"Modelo",model],
    ["Teléfono",@client.phone,"Dominio",@vehicle.domain],
    ["Correo Electrónico",@client.email,"",""]
]
pdf.table data do
  cells.borders=[]
  row(0).borders = [:top]
  columns(0..3).width = 138
end


data =[
    ["Comentario",@budget.comment],
]

pdf.move_down(5)
pdf.table data do
  cells.borders = [:top]
  row(0).border_width = 0.8
  columns(0).width = 138
  columns(1).width = 414
end


data =[
    ["Servicios",""],
]

pdf.move_down(5)
pdf.table data do
  row(0).font_style = :bold
  cells.borders = [:top,:bottom]
  row(0).border_width = 0.8
  columns(0..1).width = 277
end

pdf.move_down(5)

@budget.my_services.each do |service|
    data = [
        [service.service_type.name,"Cantidad","Precio",number_to_currency(service.total_price)]
    ]

    service.my_material_services.each do |ms|
      mat = ms.material_service_type ? "[#{ms.material_service_type.material.prov_code}] #{ms.material_service_type.material.detail}" : ms.material
      data << [mat,ms.amount,number_to_currency(ms.price),number_to_currency(ms.total_price)]
    end

    pdf.table data do
      cells.borders=[]
      row(0).font_style = :bold
      column(0).width = 314
      columns(1..3).width = 80
      columns(1..3).style{|c| c.align = :right}
    end
end

data= [["",number_to_currency(@budget.total_price)]]
pdf.table data do
  cells.borders=[:bottom]
  cells.style(:size =>10,:font_style=>:bold)
  column(0).width = 474
  columns(1).width = 80
  columns(1).style{|c| c.align = :right}
end
