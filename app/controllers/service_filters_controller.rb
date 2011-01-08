class ServiceFiltersController < ApplicationController
  layout "application", :except => [:create] 
  
  def index
    @filters = ServiceFilter.find(:all)
  end

  def create
    filter = ServiceFilter.find_by_name(params[:service_filter][:name])
    unless filter
      filter = ServiceFilter.new(params[:service_filter])
      filter.user = current_user
      filter.save
    else
      filter.update_attributes(params[:service_filter])
    end
    @service_filters = current_user.service_filters
    
    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.xml  { render :xml => @companies }
    end
    
  end

  def destroy
    @filter = ServiceFilter.find(params[:id])
    @filter.destroy
    redirect_to service_filters_path
  end
  
  
  
end

