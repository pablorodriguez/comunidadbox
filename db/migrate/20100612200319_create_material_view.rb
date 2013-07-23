class CreateMaterialView < ActiveRecord::Migration
  def self.up
    execute "
      CREATE VIEW material_details      
      as
      select 
        m.prov_code AS prov_code,
        m.id AS material_id,
        m.category_id AS category_id,
        m.sub_category_id AS sub_category_id,
        mst.service_type_id AS service_type_id,
        pl.id AS price_list_id,
        mst.id AS material_service_type_id,
        pli.price AS price,
        concat('[',m.prov_code,'] ',ucase(m.name)) AS detail_upper,
        concat('[',m.prov_code,'] ',m.name) AS detail,
        pl.company_id AS company_id 
      from 
        ((((materials m 
        join service_types st) 
        join material_service_types mst) 
        join price_lists pl on((pl.active = 1))) 
        join price_list_items pli) 
      where 
        ((pli.price_list_id = pl.id) 
        and (pli.material_service_type_id = mst.id) 
        and (m.id = mst.material_id) 
        and (mst.service_type_id = st.id))
    "
  end

  def self.down
    execute "DROP VIEW material_details"
  end
end
