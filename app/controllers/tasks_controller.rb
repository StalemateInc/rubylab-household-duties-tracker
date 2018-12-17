class TasksController < ApplicationController
  layout "dashboard"
  before_action :find_task, except: %i[index create new]
  before_action :find_group, except: %i[show destroy]

  # GET /groups/:group_id/tasks
  def index
    @tasks = @group.tasks
  end

  # POST /groups/:group_id/tasks
  def create
    set_current_user_as_creator
    @task = @group.tasks.build(task_params)
    redirect_to [@group, @task] if @task.save
  end

  # GET /groups/:group_id/tasks/new
  def new
    @task = Task.new
  end

  # GET /groups/:group_id/tasks/:id/edit
  def edit; end

  # GET /groups/:group_id/tasks/:id
  def show
    redirect_to groups_path unless can? :read, @task
  end

  # PATCH/PUT /groups/:group_id/tasks/:id
  def update
    redirect_to [@group, @task] if @task.update(task_params)
  end

  # DELETE /groups/:group_id/tasks/:id
  def destroy
    @task.destroy
    redirect_to group_tasks_path
  end

  private

  def set_current_user_as_creator
    params[:task][:creator_id] = current_user.id.to_s
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :expires_at,
                                 :creator_id, :executor_id)
  end
end
