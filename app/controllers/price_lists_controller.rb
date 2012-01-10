class PriceListsController < ApplicationController
  
  def show
    @price_list = PriceList.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @price_list }
    end
  end
  
  def import_price
    name = params[:name]
    PriceList.import_price name
    redirect_to :action=>:index
  end
  
  # GET /models/1/edit
  def edit
    @price_list = PriceList.find(params[:id])
  end
  
  # GET /models/new
  # GET /models/new.xml
  def new
    @price_list = PriceList.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @model }
    end
  end
  
  # POST /models
  # POST /models.xml
  def create
    @price_list = PriceList.new(params[:price_list])
    @price_list.active=0
    @price_list.company = get_company
    respond_to do |format|
      if @price_list.save
        flash[:notice] = 'La Lista de Precio de grabo con exito'
        format.html { redirect_to(@price_list) }
        format.xml  { render :xml => @price_list, :status => :created, :location => @price_list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @price_list.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def index
    @price_lists = get_all_price_list(get_company.id)
  end
  
  def get_all_price_list(company_id)
    PriceList.where("company_id = ?",company_id)
  end
  
  def copy
    @price_lists = get_all_price_list(get_company.id)
    render :action =>:index
  end
  
  def activate
    pl= PriceList.find(params[:id])
    company_id = get_company.id
    plActive = PriceList.where("company_id = ? and active=1",company_id).first
    PriceList.transaction do      
      if plActive
        plActive.active=false
        plActive.save
      end
      pl.active=true
      pl.save
      
    end
    
    redirect_to :action=>:index
  end
  
   # PUT /models/1
  # PUT /models/1.xml
  def update
    @price_list = PriceList.find(params[:id])

    respond_to do |format|
      if @price_list.update_attributes(params[:price_list])
        flash[:notice] = 'Lista de precio actualizada.'
        format.html { redirect_to price_lists_path}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @price_list.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update_item_price
    plid= params[:id]
    ids = params[:ids]
    puts "##### #{ids}"
    page = params[:page]
    item_update = params[:item_update]
    percentage = params[:percentage]
    service_types_ids = params[:service_type_ids]
    material = params[:material]
    update_all(plid,percentage) if (item_update == "all")      
    update_all_page(plid,percentage,service_types_ids,material)if (item_update == "all_page")
    update_actual_page(plid,ids) if (item_update == "actual_page")
    
    redirect_to :action=>:index
  end
  
  def items
    id = params[:id]
    @page = params[:page] || 1
    @service_type_ids = params[:service_type_ids] ? params[:service_type_ids].values : []
    @percentage = params[:percentage] || ""
    @material = params[:material] || ""
    company_id= get_company.id
    @materials = MaterialServiceType.m(company_id,id,@service_type_ids,@material,@page.to_i)
      
    @price_list = PriceList.find id
  end
  
  
  private
  
  def get_materials
    id = params[:id]
    @page = params[:page] || 1
    @service_type_ids = params[:service_type_ids] || []
    @percentage = params[:percentage] || ""
    @material = params[:material] || ""
    company_id = get_company.id
    @materials = MaterialServiceType.m(company_id,id,@service_type_ids,@material,@page)
    @materials
  end
  
  def update_actual_page(plid,ids)
    PriceList.transaction do
        @price_list = PriceList.find plid
        ids.each_pair do |key,value|
          unless value.empty?
            mst=MaterialServiceType.find key.to_i
            items = PriceListItem.find_by_price_list_id_and_material_service_type_id(plid,key)
            unless items.nil?
              items.price = value.to_f
              items.save
            else
              pli=PriceListItem.new        
              pli.material_service_type=mst
              pli.price = value.to_f
              @price_list.price_list_items << pli                     
            end          
          end
      end    
    end
  end
  
  def update_all_page(plid,percentage,service_types_ids,material)
    materials = MaterialServiceType.m(company_id,id,service_types_ids,material,-1)
    PriceList.transaction do
        materials.each do |key|
          mst=MaterialServiceType.find key.id
          items = PriceListItem.find_by_price_list_id_and_material_service_type_id(plid,key)
          items.price = items.price * (1 + (percentage.to_f / 100))
          items.save
      end    
    end
  end
  
  def update_all(plid,percentage)
    percentage = 1 + (percentage.to_f / 100)
    ActiveRecord::Base.connection.execute("update price_list_items set price = price * #{percentage} where price_list_id =#{plid}")
  end
  
end
