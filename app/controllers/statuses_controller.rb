class StatusesController < ApplicationController

  layout "application"
  
  def index
    get_custom_statuses
  end

  def new
    @custom_status = Status.new
  end

   def edit
    @custom_status = Status.find(params[:id])
  end

  def create
    @custom_status = Status.new(params[:status])
    @custom_status.company = get_company
    if @custom_status.save
      flash[:notice] = 'Estado creado.'
      redirect_to(@custom_status)
    else
      render :action => "new"
    end
  end

  def show
    @custom_status = Status.find(params[:id])
  end

  def update
    @custom_status = Status.find(params[:id])
    if @custom_status.update_attributes(params[:status])
      flash[:notice] = 'Estado actualizado.'
      redirect_to(@custom_status)
    else
      render :action => "edit"
    end
  end

  def destroy
    custom_status = Status.find(params[:id])
    if custom_status
      custom_status.destroy
    end
    redirect_to(statuses_url)
  end

  private
    def get_custom_statuses
      company = get_company
      @custom_statuses = company.custom_statuses
    end
end