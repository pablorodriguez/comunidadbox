class CreateMaterialView < ActiveRecord::Migration
  def self.up
    execute "
      CREATE VIEW material_details      
      as
      select
        m.id as material_id,
        m.category_id as category_id,
        m.sub_category_id as sub_category_id,
        mst.service_type_id as service_type_id,
        pl.id as price_list_id,
        mst.id as material_service_type_id,
        pli.price as price,
        concat('[',m.code,'] ',ucase(m.name)) as detail_upper,
        concat('[',m.code,'] ',m.name) as detail,
        pl.company_id as company_id
        from ((((materials m join service_types st)
        join material_service_types mst)
        join price_lists pl on((pl.active = 1)))
        join price_list_items pli)
        where ((pli.price_list_id = pl.id)
        and (pli.material_service_type_id = mst.id)
        and (m.id = mst.material_id) and (mst.service_type_id = st.id))
    "
  end

  def self.down
    execute "DROP VIEW material_details"
  end
end
