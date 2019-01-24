class TasksController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_current_user_as_creator, only: :create
  before_action :find_task, only: %i[edit show update destroy]
  before_action :find_group, except: %i[show destroy]
  before_action :find_task_for_rating, only: %i[prompt_rate rate]
  authorize_resource :task, through: :group

  # GET /groups/:group_id/tasks
  def index
    @tasks = @group.tasks.page(params[:page])
  end

  # POST /groups/:group_id/tasks
  def create
    @task = @group.tasks.create(task_params)
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
    if @task.update(task_params)
      flash[:notice] = I18n.t('flash.task.update_success')
    else
      flash[:alert] = I18n.t('flash.task.update_failure')
    end
    redirect_to [@group, @task]
  end

  # DELETE /groups/:group_id/tasks/:id
  def destroy
    if @task.destroy
      flash[:notice] = I18n.t('flash.task.destroy_success')
      redirect_to group_tasks_path
    else
      flash[:alert] = I18n.t('flash.task.destroy_failure')
      redirect_to @task
    end
  end

  def prompt_rate
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404.html", layout: true, status: 404 }
      format.json { head :no_content }
      format.js
    end
  end

  def rate
    if @task.update(rate_params.merge(status: :closed))
      respond_to do |format|
        format.html { redirect_back(fallback_location: @task) }
        format.json { render :no_content }
        format.js
      end
    end
  end

  private

  def set_current_user_as_creator
    params[:task][:creator_id] = current_user.id
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def find_task_for_rating
    @task = Task.find(params[:task_id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :category_id,
                                 :creator_id, :executor_id, tag_list: [])
  end

  def rate_params
    params.require(:task).permit(:rating)
  end
end
