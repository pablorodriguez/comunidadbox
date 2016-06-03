class CompanyAttributesController < ApplicationController

  def index
    unless current_user.companies.empty?
      @companies = current_user.companies
    else
      @companies = [current_user.company]
    end
  end
  
  def show
    @company_attribute = CompanyAttribute.find params[:id]
    authorize! :show, @company_attribute
  end

  def destroy
    @company_attributre = CompanyAttribute.find(params[:id])
    authorize! :destroy, @company_attribute
    
    @company_attribute.destroy

    respond_to do |format|
      format.html { redirect_to(company_attributes_url) }
      format.xml  { head :ok }
    end
  end

  def edit
    @company_attribute = CompanyAttribute.find(params[:id])
    authorize! :update, @company_attribute
  end

  def update
    @company_attribute = CompanyAttribute.find(params[:id])
    authorize! :update, @company_attribute

    respond_to do |format|
      if @company_attribute.update_attributes(params[:company_attribute])        
        format.html { redirect_to :action => "show" }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def create
    @company_attribute = CompanyAttribute.new(params[:company_attribute])
    @company_attribute.company = current_user.company_active
     authorize! :create, @company_attribute
    if @company_attribute.save
      redirect_to @company_attribute
    else
      render :action => 'new'
    end
  end

  def new
    @company_attribute = CompanyAttribute.new({:company_id => current_user.company_active.id})
  end

end
