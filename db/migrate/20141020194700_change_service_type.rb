# encoding: utf-8

class ChangeServiceType < ActiveRecord::Migration
  def up
    add_column :service_types, :company_id, :integer
    add_index :service_types, :company_id    
    add_foreign_key(:service_types, :companies)

    add_column :materials, :company_id, :integer
    add_column :materials, :disable, :boolean
    add_index :materials, :company_id 

    add_foreign_key(:materials, :companies)

    add_column :material_service_types, :company_id, :integer
    add_index :material_service_types, :company_id    
    add_foreign_key(:material_service_types, :companies)

    
    execute("update service_types set company_id = 28 where id in (13,14)")
    execute("update service_types set company_id = 28 where id in (13,14)")

    execute "update materials set company_id = 12 where company_id is null"
    execute "update material_service_types set company_id = 12 where company_id is null"

    ServiceType.update(1,name: "Cambio de Aceite")
    ServiceType.update(2,name: "Cambio de Neumáticos")
    ServiceType.update(3,name: "Alineación y Balanceo")
    ServiceType.update(4,name: "Mantenimiento General")
    ServiceType.update(5,name: "Tren Delantero")
    ServiceType.update(7,name: "Suspensión")
    ServiceType.update(8,name: "Frenos y Embragues")
    ServiceType.update(9,name: "Amortiguación")
    ServiceType.update(10,name: "Accesorios 4x4")
    ServiceType.update(11,name: "LLantas Deportivas - Originales")
    ServiceType.update(12,name: "Tren Trasero")
    ServiceType.update(13,name: "Servicios en Garantía")
    ServiceType.unscoped.update(14,name: "Servicios Fuera de Garantía")
    ServiceType.update(15,name: "Alineación")
    ServiceType.update(16,name: "Balanceo")
    


    [22,2].each do |company_id|
      sts = Hash.new
      sts[1] = ServiceType.create(name: "Cambio de Aceite",kms: 10000,active:1,code: "CA",company_id: company_id)
      sts[3] = ServiceType.create(name: "Alineación y Balanceo",kms: 10000,active:1,code: "MG",company_id: company_id)
      sts[4] = ServiceType.create(name: "Mantenimiento General",kms: 10000,active:1,code: "MG",company_id: company_id)
      sts[5] = ServiceType.create(name: "Tren Delantero",kms: 20000,active:1,code: "CA",company_id: company_id)
      sts[8] = ServiceType.create(name: "Frenos y Embragues",kms: 10000,active:1,code: "CA",company_id: company_id)
      sts[12] = ServiceType.create(name: "Tren Trasero",kms: 10000,active:1,code: "CA",company_id: company_id)

      sts.each do |st_id,st| 
          execute %Q{update events as e inner join services s on s.id = e.service_id 
              inner join workorders wo on wo.id = s.workorder_id 
              inner join service_types st on e.service_type_id= st.id 
              inner join companies c on wo.company_id = c.id set e.service_type_id= #{st.id} 
              where e.service_type_id = #{st_id} and c.id = 22}
      end
    end
    
  end

  def down
    remove_column :service_types,:company_id    
    remove_column :materials,:company_id
    remove_column :material_service_types,:company_id
    
  end
end

