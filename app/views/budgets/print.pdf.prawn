fs=8
company = @budget.creator.company
pdf.font_size fs
pdf.move_down(15)

pdf.image "#{RAILS_ROOT}/public/images/logo_bw.png",:at=>[450,820],:scale =>0.40
pdf.text company.name,:size => fs +4,:style =>:bold


pdf.move_down(5)
pdf.text "Presupuesto Nro: #{@budget.id}",:size=>fs,:size=>10,:style =>:bold
pdf.move_up(11)
pdf.text "Operario: #{@budget.creator.full_name}",:align=>:right
pdf.text l(@budget.created_at),:size=> 6,:align=>:right
pdf.move_down(20)

data =[
    ["Cliente","Autómovil"],
]
            
pdf.table data,:column_widths=>[277,277],:cell_style=>{:size => 10,:font_style=>:bold}

data=[
    ["Nombre",@budget.first_name,"Marca",@budget.brand.name],
    ["Apellido",@budget.last_name,"Modelo",@budget.model.name],
    ["Teléfono",@budget.phone,"Dominio",@budget.domain],
    ["Correo Electrónico",@budget.email,"",""]
]
pdf.table data,:column_widths=>[138,139,138,139]

pdf.move_down(8)
pdf.text "Servicios",:size =>10,:style=>:bold
pdf.move_down(5)

@budget.services.each do |service|
    data = [
        [service.service_type.name,"","",""]
    ]

    service.material_services.each do |ms|      
        data << [ms.material_service_type.material.detail,ms.amount,number_to_currency(ms.price),number_to_currency(ms.total_price)] if ms.material_service_type
        data << [ms.material,ms.amount,number_to_currency(ms.price),number_to_currency(ms.total_price)] unless ms.material_service_type
    end
                
    pdf.table data do
      column(0).width = 314
      columns(1..3).width = 80
      columns(1..3).style{|c| c.align = :right}      
    end        
end

data= [["",number_to_currency(@budget.total_price)]]
pdf.table data do
  cells.style(:size =>10,:font_style=>:bold)
  column(0).width = 474
  columns(1).width = 80
  columns(1).style{|c| c.align = :right}
end
