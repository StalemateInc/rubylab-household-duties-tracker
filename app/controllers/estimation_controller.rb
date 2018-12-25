class EstimationController < ApplicationController
  layout "dashboard"
  before_action :find_group
  before_action :find_task

  def estimate
    redirect_back_to_task unless @task.executor == current_user
  end

  def send_estimate
    params[:task][:status] = :ready
    redirect_back_to_task if @task.update(estimation_create_params)
  end

  def confirm
    redirect_back_to_task if @task.confirm_estimation
  end

  def reject
    redirect_back_to_task if @task.reject_estimation
  end

  # GET groups/:group_id/tasks/:task_id/estimate/pause
  def prompt_pause; end

  # POST groups/:group_id/tasks/:task_id/estimate/pause
  def pause
    pausing = PauseSelectedTask.call(task_params: estimation_pause_params_task,
                                     comment_params: estimation_pause_params_comment,
                                     task: @task,
                                     user: current_user)
    respond_to do |format|
      if pausing.success?
        format.html { redirect_back(fallback_location: @task) }
        format.json { head :no_content }
      end
    end
  end

  private

  def redirect_back_to_task
    redirect_to [@group, @task]
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_task
    @task = Task.find(params[:task_id])
  end

  def estimation_create_params
    params.require(:task).permit(:expires_at, :status)
  end

  def estimation_pause_params_task
    params.require(:estimation).permit(:new_expires_at)
  end

  def estimation_pause_params_comment
    params.require(:estimation).permit(:content, :new_expires_at)
  end

end
