class TasksController < ApplicationController
  layout "dashboard"
  before_action :find_task, except: %i[index create new]

  # GET /groups/:group_id/tasks
  def index
    @group = Group.find(params[:group_id])
    @tasks = @group.tasks
  end

  # POST /groups/:group_id/tasks
  def create
    @group = Group.find(params[:group_id])
    @task = @group.tasks.build(task_params)
    redirect_to [@group, @task] if @task.save
  end

  # GET /groups/:group_id/tasks/new
  def new
    @group = Group.find(params[:group_id])
    @task = Task.new
  end

  # GET /groups/:group_id/tasks/:id/edit
  def edit

  end

  # GET /groups/:group_id/tasks/:id
  def show; end

  # PATCH/PUT /groups/:group_id/tasks/:id
  def update

  end

  # DELETE /groups/:group_id/tasks/:id
  def destroy
    @task.destroy
    redirect_to group_tasks_path
  end

  private

  def find_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :ttc, :creator_id, :executor_id)
  end
end
