fs=8
company = @budget.creator.company
pdf.font_size fs
pdf.move_down(15)

pdf.image "#{RAILS_ROOT}/public/images/logo_bw.png",:at=>[450,820],:scale =>0.40
pdf.text company.name,:size => fs +4,:style =>:bold
pdf.text "#{company.full_address}, #{company.phone}"


pdf.move_down(5)
pdf.text "Presupuesto Nro: #{@budget.id}",:size=>fs,:size=>10,:style =>:bold
pdf.move_up(14)
pdf.text "Realizado: #{l(Date.parse(@budget.created_at.to_s))}",:align=>:right,:size=>10,:style =>:bold
pdf.text "Operario: #{@budget.creator.full_name}",:size =>6,:align=>:right
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

data=[
    ["Nombre",@client.first_name,"Marca",@car.brand.name],
    ["Apellido",@client.last_name,"Modelo",@car.model.name],
    ["Teléfono",@client.phone,"Dominio",@car.domain],
    ["Correo Electrónico",@client.email,"",""]
]
pdf.table data do
  cells.borders=[]
  row(0).borders = [:top]
  columns(0..3).width = 138
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

@budget.services.each do |service|
    data = [
        [service.service_type.name,"Cantidad","Precio",number_to_currency(service.total_price)]
    ]

    service.material_services.each do |ms|      
        data << [ms.material_service_type.material.detail,ms.amount,number_to_currency(ms.price),number_to_currency(ms.total_price)] if ms.material_service_type
        data << [ms.material,ms.amount,number_to_currency(ms.price),number_to_currency(ms.total_price)] unless ms.material_service_type
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
