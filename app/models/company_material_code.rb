class CompanyMaterialCode < ActiveRecord::Base
  belongs_to :company
  belongs_to :material_service_type
  attr_accessible :code

  def self.find_by_user(plid, page, user)
  	list = []

  	if plid.present?

  		pli = PriceListItem.where("price_list_id = ?", plid).limit(1000) if page.blank? || page.to_i < 0
  		pli = PriceListItem.where("price_list_id = ?", plid).paginate(:per_page=>20,:page =>page) if page.to_i >= 0

  		#pli.sort! {|a,b| a.material_service_type.service_type.name + a.material.name <=> b.material_service_type.service_type.name + b.material.name}

  		pli.each do |item|
  			if item.company_material_code.present?
  				list << item.company_material_code
  			else
  				compMaterialCode = CompanyMaterialCode.new
  				compMaterialCode.company = user.company_active
  				compMaterialCode.material_service_type = item.material_service_type
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

      #item = PriceListItem.find_by_price_list_id_and_material_service_type_id(plid, row['mst_id'])

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
