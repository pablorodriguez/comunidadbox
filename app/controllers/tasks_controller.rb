class TasksController < ApplicationController

  def index
    @tasks = Task.find(:all)
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(params[:task])
    if @task.save
      flash[:notice] = 'La Tarea ha sido creada.'
      redirect_to(@task)
    else
      render :action => "new"
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(params[:task])
      flash[:notice] = 'Tarea actualizada.'
      redirect_to(@task)
    else
      render :action => "edit"
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to tasks_path
  end
end

