class GuestsController < ApplicationController

  skip_before_filter :authenticate_user!,:only => [:new]
  
  layout :false
  # GET /guests
  # GET /guests.xml
  def index
    @guests = Guest.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @guests }
    end
  end

  # GET /guests/1
  # GET /guests/1.xml
  def show
    @guest = Guest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @guest }
    end
  end

  # GET /guests/new
  # GET /guests/new.xml
  def new
    @guest = Guest.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @guest }
    end
  end

  # GET /guests/1/edit
  def edit
    @guest = Guest.find(params[:id])
  end

  # POST /guests
  # POST /guests.xml
  def create
    @guest_n = Guest.new(params[:guest])
    @guest = Guest.new

    respond_to do |format|
      if @guest_n.save
        format.html { redirect_to vgneumaticos_path, :notice => 'Muchas gracias por ingresar sus datos'}
        format.xml  { render :xml => @guest_n, :status => :created, :location => @guest }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @guest_n.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /guests/1
  # PUT /guests/1.xml
  def update
    @guest = Guest.find(params[:id])

    respond_to do |format|
      if @guest.update_attributes(params[:guest])
        format.html { redirect_to(@guest, :notice => 'Guest was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @guest.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /guests/1
  # DELETE /guests/1.xml
  def destroy
    @guest = Guest.find(params[:id])
    @guest.destroy

    respond_to do |format|
      format.html { redirect_to(guests_url) }
      format.xml  { head :ok }
    end
  end
end
