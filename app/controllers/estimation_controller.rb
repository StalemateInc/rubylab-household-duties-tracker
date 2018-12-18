class EstimationController < ApplicationController
  layout "dashboard"
  before_action :find_group
  before_action :find_task

  def estimate
    redirect_back_to_task unless @task.executor == current_user
  end

  def send_estimate
    params[:task][:status] = :ready
    redirect_back_to_task if @task.update(estimation_params)
  end

  def confirm
    redirect_back_to_task if @task.confirm_estimation
  end

  def reject
    redirect_back_to_task if @task.reject_estimation
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

  def estimation_params
    params.require(:task).permit(:expires_at, :status)
  end

end
