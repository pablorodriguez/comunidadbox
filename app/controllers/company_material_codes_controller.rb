class CompanyMaterialCodesController < ApplicationController
layout "application"

  def index
    @page = params[:page] || 1

    pl = PriceList.find_active_price_list current_user

    @companyMaterialCodes = CompanyMaterialCode.find_by_user(pl.id, @page, current_user)
    @totalCMCs = CompanyMaterialCode.find_to_paginate(pl.id, @page).paginate(:per_page=>20,:page =>@page.to_i)
    
    @count= @companyMaterialCodes.count()   
  end

  def export
  	pl = PriceList.find_active_price_list current_user
  	csv = CompanyMaterialCode.to_csv pl.id, current_user
  	unless csv.empty?
      respond_to do |format|
        format.csv {send_data csv_string.encode("iso-8859-1"), :filename => "materialCodes.csv", :type => 'text/csv; charset=iso-8859-1; header=present'}
        format.html {redirect_to company_material_codes_path}
      end
  	else
      flash[:alert] = t("Error")
      redirect_to company_material_codes_path
  	end
  end

  def import
  	if params[:file].present?
  		pl = PriceList.find_active_price_list current_user
      CompanyMaterialCode.from_csv pl.id, params[:file], current_user
      
    else
      flash[:alert] = t("Error")
    end

    redirect_to company_material_codes_path
  	
  end
end