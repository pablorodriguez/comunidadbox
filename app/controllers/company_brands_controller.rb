class CompanyBrandsController < ApplicationController

  layout "application"
  
  def index
    @company = get_company
    @company_brands = @company.get_headquarter.brands
    company_brands_ids = @company_brands.map{|x| x.id}
    @missing_brands = Brand.all.reject{|x| company_brands_ids.include? x.id}
  end

  def new
    if params[:brand][:brand_id].present?
      @brand = Brand.find(params[:brand][:brand_id])
      @company_models = get_company.headquarter_models_by_brand(@brand)
    else
      flash[:error] = "Debe seleccionar una Marca"
      redirect_to company_brands_path
    end
  end

  def add_models
    if params[:models]
      params[:models].each do |key, value|
        get_company.assign_model_to_headquarter(key.to_i, value == "1")
      end
    end
    redirect_to company_brands_path
  end

  def remove
    if params[:id]
      brand = Brand.find(params[:id])
      get_company.remove_brand_model_of_headquarters(brand) if brand
    end
    redirect_to company_brands_path
  end
end