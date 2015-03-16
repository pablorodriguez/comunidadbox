class StatusesController < ApplicationController

  layout "application"
  
  def index
    get_custom_statuses
  end

  def new
    @status = Status.new
  end

   def edit
    @status = Status.find(params[:id])
  end

  def create
    @status = Status.new(params[:status])
    @status.company = get_company
    if @status.save
      flash[:notice] = 'Estado creado.'
      redirect_to(@status)
    else
      render :action => "new"
    end
  end

  def show
    @status = Status.find(params[:id])
  end

  def update
    @status = Status.find(params[:id])
    if @status.update_attributes(params[:status])
      flash[:notice] = 'Estado actualizado.'
      redirect_to(@status)
    else
      render :action => "edit"
    end
  end

  def destroy
    status = Status.find(params[:id])
    if status
      status.destroy
    end
    redirect_to(statuses_url)
  end

  private
    def get_custom_statuses
      company = get_company
      @statuses = company.statuses
    end
end