
class MaterialServiceType < ActiveRecord::Base
  attr_accessible :material_id, :service_type_id,:company_id,:protected

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

  def can_delete?
    MaterialService.where("material_service_type_id = ?",self.id).count > 0 ? false : true
  end

  def self.generate_select_join_str(company_id,price_list_id,service_type_ids)
    select_str ="material_service_types.id,material_service_types.material_id,m.code,m.name,material_service_types.service_type_id,st.name,pli.price  "

    join_str =  "LEFT OUTER JOIN price_list_items as pli ON pli.material_service_type_id = material_service_types.id and pli.price_list_id=#{price_list_id} "
    join_str += " INNER JOIN service_types as st ON st.id = material_service_types.service_type_id and st.company_id = #{company_id} "

    join_str += " and material_service_types.service_type_id in (#{service_type_ids.join(",")})" if (service_type_ids.size > 0)

    join_str += " LEFT OUTER JOIN materials as m ON material_service_types.material_id = m.id"
    return [select_str,join_str]

  end

  def self.m(company_id,price_list_id,service_type_ids,material,page)
    select_str,join_str = MaterialServiceType.generate_select_join_str(company_id,price_list_id,service_type_ids)
    if (page >=0)
      return MaterialServiceType.paginate(:per_page=>20,:page =>page,:select => select_str,:conditions=>['m.name LIKE ?',"%#{material}%"] ,:joins=>join_str,:order =>"st.name,m.name")
    else
      return MaterialServiceType.find(:all,:select => select_str,:conditions=>['m.name LIKE ?',"%#{material}%"] ,:joins=>join_str)
    end
  end

  def self.material_to_export company_id,price_list_id,service_type_ids
    select_str,join_str = MaterialServiceType.generate_select_join_str(company_id,price_list_id,service_type_ids)
    MaterialServiceType.select(select_str).joins(join_str).limit(50)
  end

  def self.to_csv_for_update_price(plid, user)
    #para desarrollar mas rapido.. solo traigo la pagina uno para exportar
    msList = material_to_export(user.headquarter.id, plid, []) if PriceList.find_by_id(plid).present?
    #sin paginar.. trae todos los items
    #msList = m(user.company_active.id, plid, [], nil, -1) if PriceList.find_by_id(plid).present?

    CSV.generate do |csv|
      csv << ['plid','id','service','material code','material name','price']

      if msList.present?
        msList.each do |item|
          if item.material
            csv << [plid,item.id,item.name,item.code, item.material.name, item.price.to_s]
          end
        end
      end
    end

  end

  def self.import_to_update_price(plid, file, current_user,encode)
    pl = PriceList.find_by_id plid
    CSV.foreach(file.path, :headers => true,:encoding => encode) do |row|
      #si la playlist no existe o es distinta a la de la que se hizo el export => no actualizo nada
      if pl.blank? || plid.to_i != row['plid'].to_i
        puts 'placeList incorrecta'
        return
      end
      mst_id= row['id'].to_i
      mst = find(mst_id)

      item = PriceListItem.where("price_list_id = ? and material_service_type_id = ?",plid,mst_id).first
      #find_by_price_list_id_and_material_service_type_id(plid, row['id'])
      if row['price'].present?
        if item && item.price != row['price'].to_f
          item.price = row['price'].to_f
          item.save
        else
          pli = PriceListItem.new
          pli.material_service_type = mst
          pli.price = row['price'].to_f
          pl.price_list_items << pli
        end
      else
        if item
          item.delete
        end
      end

    end
  end

end


