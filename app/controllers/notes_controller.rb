# encoding: utf-8
class NotesController < ApplicationController
  layout "application", :except => [:create,:destroy]
  # GET /notes
  # GET /notes.xml
  def index
    page = params[:page] || 1
    per_page = 10
    @notes = current_user.all_notes.paginate(:page =>page,:per_page =>per_page)

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
      @note.user = event.vehicle.user
    else
      @note = Note.new(params[:note])
    end

    set_note_element_id
    @id = params[:element_id]

    @note.creator = current_user

    respond_to do |format|
      if @note.save
        format.js {render :file=>"notes/new_note",:layout => false}
      else
        format.js {render :file=>"notes/error",:layout => false}
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

  def set_note_element_id
    @element_id = "#notes .notes_container"
    @element_id = "#budget_#{@note.budget_id}" if @note.budget_id
    @element_id = "#workorder_#{@note.workorder_id}" if @note.workorder_id
    @element_id = "#event_notes .notes_container" if @note.event_id
  end

  # DELETE /notes/1
  # DELETE /notes/1.xml
  def destroy
    @note = Note.find(params[:id])
    @note_id = @note.id
    @wo_id = @note.workorder_id

    set_note_element_id

    @note.destroy

    respond_to do |format|
      format.html { redirect_to(notes_url) }
      format.js {render :layout => false}
      format.xml  { head :ok }
    end
  end
end
