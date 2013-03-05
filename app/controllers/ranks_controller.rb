class RanksController < ApplicationController
  layout "application", :except => [:create]
  # GET /ranks
  # GET /ranks.xml
  def index
    @ranks = Rank.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ranks }
    end
  end

  # GET /ranks/1
  # GET /ranks/1.xml
  def show 
    @rank = Rank.find(params[:id])    
    if(params[:cat]=="company")
      work_orders = Workorder.find_all_by_company_rank_id @rank.id
      company = Company.find work_orders.first.company_id
      
      @pagetitle = "Calificacion de: " << company.name
    else
      work_orders = Workorder.find_all_by_user_rank_id @rank.id
      car = work_orders.first.car
      user = User.find car.user_id
      @pagetitle = car.domain << "-" << user.last_name << ", " <<user.first_name
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rank }
    end
  end

  # GET /ranks/new
  # GET /ranks/new.xml
  def new
    @rank = Rank.new
    @work_order = Workorder.find params[:wo_id]
    @car = @work_order.car
    @cat = params[:cat]
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rank }
    end
  end

  # GET /ranks/1/edit
  def edit
    @rank = Rank.find(params[:id])
  end

  # POST /ranks
  # POST /ranks.xml
  def create
    @rank = Rank.new(params[:rank])
    respond_to do |format|
      if @rank.save
        @work_order = @rank.workorder
        format.js {render :action =>"create",:layout =>false}
      else
        @work_order = @rank.workorder
        format.js {render :action =>"create",:layout =>false}
        format.xml  { render :xml => @rank.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ranks/1
  # PUT /ranks/1.xml
  def update
    @rank = Rank.find(params[:id])
    respond_to do |format|
      @rank.update_attributes(params[:rank])
      @work_order = @rank.workorder
      format.js {render :action =>"create",:layout =>false}
    end
  end

  # DELETE /ranks/1
  # DELETE /ranks/1.xml
  def destroy
    @rank = Rank.find(params[:id])
    @rank.destroy

    respond_to do |format|
      format.html { redirect_to(ranks_url) }
      format.xml  { head :ok }
    end
  end
end
