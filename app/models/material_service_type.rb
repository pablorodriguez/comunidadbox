class MaterialServiceType < ActiveRecord::Base
 attr_accessible :material_id, :service_type_id

  belongs_to :material
  belongs_to :service_type
  has_many :price_list_items
  has_one :price_list_item_active, :class_name =>"PriceListItem",:include=>"price_list", :conditions =>["price_lists.active =1"]
  has_one :company_material_code
  
  accepts_nested_attributes_for :material
  accepts_nested_attributes_for :service_type
  
  def self.materials company_id
    MaterialServiceType.includes({:price_list_items_active=>{:price_list=>{}},:service_type=>{:companies=>{}}}).where("companies.id = ? ",company_id)
  end
  
  def self.m(company_id,price_list_id,service_type_ids,material,page)
        
    select_str ="material_service_types.id,material_service_types.material_id,m.code,m.name,material_service_types.service_type_id,st.name,pli.price  "
    
    join_str ="LEFT OUTER JOIN price_list_items as pli ON pli.material_service_type_id = material_service_types.id and pli.price_list_id=#{price_list_id} 
    LEFT OUTER JOIN service_types as st ON st.id = material_service_types.service_type_id"
    
    if (service_type_ids.size > 0)
      join_str += " and material_service_types.service_type_id in (#{service_type_ids.join(",")})"
    end
    
    join_str += " INNER JOIN company_services as cs ON cs.service_type_id = st.id and cs.company_id=#{company_id} LEFT OUTER JOIN materials as m ON material_service_types.material_id = m.id" 
    
    unless material.blank?
    #  join_str += " and m.name LIKE '%#{material}%'"
    end
    
    #join_str +=" ORDER BY st.name,m.code"
    
    #data = MaterialServiceType.find(:all,:select => select_str,:conditions=>['m.name LIKE ?',"%#{material}%"] ,:joins=>join_str)
    
    if (page >=0)  
      return MaterialServiceType.paginate(:per_page=>20,:page =>page,:select => select_str,:conditions=>['m.name LIKE ?',"%#{material}%"] ,:joins=>join_str,:order =>"st.name,m.name")  
    else
      return MaterialServiceType.find(:all,:select => select_str,:conditions=>['m.name LIKE ?',"%#{material}%"] ,:joins=>join_str)
    end
  end
  
  def self.to_csv_for_update_price(plid, user)
    #para desarrollar mas rapido.. solo traigo la pagina uno para exportar
    msList = m(user.company_active.id, plid, [], nil, 1) if PriceList.find_by_id(plid).present?
    
    #sin paginar.. trae todos los items
    #msList = m(user.company_active.id, plid, [], nil, -1) if PriceList.find_by_id(plid).present?

    CSV.generate do |csv|
      csv << ['id', 'plid', 'service', 'material code', 'material name', 'price']

      if msList.present?
        msList.each do |item| 
          csv << [item.id, plid, I18n.t(item.name), item.code, item.material.name, item.price]
        end
      end
    end

  end

  def self.import_to_update_price(plid, file, current_user)
    pl = PriceList.find_by_id plid

    CSV.foreach(file.path, headers: true) do |row|
      #si la playlist no existe o es distinta a la de la que se hizo el export => no actualizo nada
      if pl.blank? || plid.to_i != row['plid'].to_i
        puts 'placeList incorrecta'
        return
      end

      mst = find_by_id(row["id"].to_i)
      item = PriceListItem.find_by_price_list_id_and_material_service_type_id(plid, row['id'])
      if row['price'].present?
        if item && item.price != row['price'].to_f
          #puts '>>>>> actualizando price:' + row.to_yaml
          item.price = row['price'].to_f
          item.save
        else
          #puts '>>>>> creando priceListItem:' + row.to_yaml
          pli = PriceListItem.new
          pli.material_service_type = mst
          pli.price = row['price'].to_f
          pl.price_list_items << pli
        end
      else
        if item
          #puts '>>>>> eliminando priceListItem:' + row.to_yaml
          item.delete
        end
      end

    end
  end

end


