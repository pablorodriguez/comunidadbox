class ModelsController < ApplicationController  
  load_and_authorize_resource
  # GET /models
  # GET /models.xml
  def index
    page = params[:page] || 1
    per_page = 42

    @brand_id = params[:b]
    @model = params[:m] || ""
    @model = "%#{@model}%"
    
    @brand_id = nil if @brand_id.try(:empty?)

    if @brand_id
      @models = Model.includes("brand").where("brand_id = ? and models.name like ?",@brand_id,@model)
    else
      @models = Model.includes("brand").where("models.name like ?",@model)
    end
    @models_count =  @models.count
    @models = @models.order('brands.name,models.name').paginate(:page =>page,:per_page =>per_page)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @models }
      format.xls { send_data Model.to_csv(col_sep: "\t") }      
    end
  end

  # GET /models/1
  # GET /models/1.xml
  def show
    @model = Model.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @model }
    end
  end

  # GET /models/new
  # GET /models/new.xml
  def new
    @model = Model.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @model }
    end
  end

  # GET /models/1/edit
  def edit
    @model = Model.find(params[:id])
  end

  # POST /models
  # POST /models.xml
  def create
    @model = Model.new(params[:model])

    respond_to do |format|
      if @model.save        
        format.html { redirect_to models_path }        
      else
        format.html { render :action => "new" }        
      end
    end
  end

  # PUT /models/1
  # PUT /models/1.xml
  def update
    @model = Model.find(params[:id])

    respond_to do |format|
      if @model.update_attributes(params[:model])
        flash[:notice] = 'Model was successfully updated.'
        format.html { redirect_to(@model) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /models/1
  # DELETE /models/1.xml
  def destroy
    @model = Model.find(params[:id])
    @model.destroy

    respond_to do |format|
      format.html { redirect_to(models_url) }
      format.xml  { head :ok }
    end
  end

  def import
    Model.import(params[:file],get_company_id)
    redirect_to brands_path, notice: "Modelos importado con exito"
  end
end
