class NotesController < ApplicationController
  layout "application", :except => [:create,:destroy]
  # GET /notes
  # GET /notes.xml
  def index
    @notes = current_user.notes

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notes }
    end
  end

  # GET /notes/1
  # GET /notes/1.xml
  def show
    @note = Note.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/new
  # GET /notes/new.xml
  def new
    @note = Note.new
    t = params[:t] || :b
    respond_to do |format|
      #format.html # new.html.erb
      format.html
      format.xml  { render :xml => @note }
    end
  end

  # GET /notes/1/edit
  def edit
    @note = Note.find(params[:id])
  end

  # POST /notes
  # POST /notes.xml
  def create

    if params[:event_id]
      event = Event.find(params[:event_id])
      @note = event.notes.build(params[:note])
    else
      @note = Note.new(params[:note])
    end

    @element_id = ".notes_container"
    @element_id = "#budget-#{@note.budget_id}" if @note.budget_id
    @element_id = "#wo_#{@note.workorder_id}" if @note.workorder_id
    @note.user = current_user   
    @note.creator = current_user    
    
    respond_to do |format|
      if @note.save
        format.html { redirect_to(notes_path)}
        format.js {render :file=>"notes/new_note.js.erb"}
        format.xml  { render :xml => @note, :status => :created, :location => @note }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.xml
  def update
    @note = Note.find(params[:id])

    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.html { redirect_to(notes_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @note.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.xml
  def destroy
    @note = Note.find(params[:id])
    @note_id = @note.id
    @wo_id = @note.workorder_id
    @element_id = "#budget-#{@note.budget_id}" if @note.budget_id
    @element_id = "#wo_#{@note.workorder_id}" if @note.workorder_id

    @note.destroy

    respond_to do |format|
      format.html { redirect_to(notes_url) }
      format.js
      format.xml  { head :ok }
    end
  end
end
