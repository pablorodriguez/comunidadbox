class CompanyMaterialCode < ActiveRecord::Base
  belongs_to :company
  belongs_to :material_service_type
  attr_accessible :code

  def self.find_by_user(plid, page, user)
  	list = []

  	if plid.present?

      query_str = "price_list_items.id, mst.id as mst_id, cmc.id as cmc_id"

      join_str = "LEFT OUTER JOIN material_service_types as mst on mst.id = price_list_items.material_service_type_id 
      INNER JOIN service_types as st ON st.id = mst.service_type_id
      LEFT OUTER JOIN company_material_codes as cmc ON mst.id = cmc.material_service_type_id 
      LEFT OUTER JOIN materials as m ON m.id = mst.material_id"

      pli = []
      if page.present? && page.to_i >= 0
        pli = PriceListItem.paginate(:per_page => 20, :page => page, :select => query_str, :conditions =>['price_list_items.price_list_id = ?',plid], :joins => join_str, :order =>"st.name,m.name")
      else
        # trae solo 1000 registros para exportar
        pli = PriceListItem.find(:all, :limit => 1000, :select => query_str, :conditions =>['price_list_items.price_list_id = ?',plid], :joins => join_str, :order =>"st.name,m.name")

        # esta linea trae todos los registros que se deben exportar
        #pli = PriceListItem.find(:all, :select => query_str, :conditions =>['price_list_items.price_list_id = ?',plid], :joins => join_str, :order =>"st.name,m.name")
      end

  		pli.each do |item|
  			if item.cmc_id.present?
  				list << CompanyMaterialCode.find(item.cmc_id)
  			else
  				compMaterialCode = CompanyMaterialCode.new
  				compMaterialCode.company = user.company_active
  				compMaterialCode.material_service_type = MaterialServiceType.find(item.mst_id)
  				list << compMaterialCode
  			end
  		end 
  	end

  	list
  end

  def self.find_to_paginate(plid, page)
		pli = PriceListItem.where("price_list_id = ?", plid).paginate(:per_page=>20,:page =>page) if page.to_i >= 0
	end

  def self.to_csv(plid, user)
    pliList = find_by_user plid, -1, user

    CSV.generate do |csv|
      csv << ['mst_id', 'service', 'material code', 'material name', 'custom code']

      if pliList.present?
        pliList.each do |item| 
          mst = item.material_service_type
          csv << [mst.id, I18n.t(mst.service_type.name), mst.material.prov_code, mst.material.name, item.code]
        end
      end
    end
  end

  def self.from_csv(plid, file, user)
    CSV.foreach(file.path, headers: true) do |row|
      #busco el material_service_type para editarle su company_material_code
      mst = MaterialServiceType.find_by_id(row["mst_id"].to_i)


      #verifico que el materialServiceType pertenezca a un priceListItem de la priceList activa del usuario
      #si no no hago nada con ese registro (con esto evito que un usuario cambie el mst_id en el csv y pueda actualizar 
      #cualquier registro)
      if mst.present? && mst.price_list_item_active.present? && mst.price_list_item_active.price_list_id == plid.to_i

        #si el usuario cargo 'custom_code'
        if mst.present? && row['custom code'].present?

          #si existe el company_material_code lo actualizo
          if mst.company_material_code.present?
            mst.company_material_code.code = row['custom code']
            mst.company_material_code.save

          #sino.. lo creo
          else
            cmc = CompanyMaterialCode.new
            cmc.material_service_type = mst
            cmc.company = user.company_active
            cmc.code = row['custom code']
            cmc.save
          end

        #si el usuario no cargo o borro el 'custom_code' y existe un company_material_code lo elmino
        elsif mst.present? && mst.company_material_code.present?
          mst.company_material_code.delete
        end
    
      end
    end    
  end

end
