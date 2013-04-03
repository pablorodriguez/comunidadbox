class ServiceTypeTemplatesController < ApplicationController


  def index
    @templates  = current_user.service_type_templates params[:id]
    respond_to do |format|
      format.html
      format.json {render "index.json.jbuilder",:layout => false}
    end
  end

  def destroy                
    @template = ServiceTypeTemplate.find(params[:id])
    authorize! :destroy, @template
    @template.destroy

    respond_to do |format|
      format.html { redirect_to(:action => 'index') }      
    end
  end

  def new
      @template = ServiceTypeTemplate.new
      #@template.material_service_type_template.build
  end

  def edit
    @template = ServiceTypeTemplate.find(params[:id])
  end

  def create
    @template = ServiceTypeTemplate.new(params[:service_type_template])
    @template.company = current_user.company
    #authorize! :create, @budget

    respond_to do |format|
      if @template.save
        format.html { redirect_to(@template) }
      else        
        format.html { render :action => "new" }        
      end
    end
  end

  def show
    @template = ServiceTypeTemplate.find(params[:id])
    respond_to do |format|
      format.html
      format.json {render "show.json.jbuilder",:layout => false}
    end
  end

  def update
    @template = ServiceTypeTemplate.find(params[:id])    
    #authorize! :update, @template
    
    respond_to do |format|
      if @template.update_attributes(params[:service_type_template])
        format.html { redirect_to(@template) }        
      else
        format.html { render :action => "edit" }        
      end
    end
  end

end
