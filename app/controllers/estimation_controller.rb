class EstimationController < ApplicationController
  layout "dashboard"
  before_action :find_group
  before_action :find_task
  before_action :find_last_postpone_comment, only: %i[accept reject]

  def estimate
    redirect_back_to_task unless @task.executor == current_user
  end

  def send_estimate
    params[:task][:status] = :pending
    params[:task][:expires_at] = Time.parse(params[:task][:expires_at]).utc.to_s
    redirect_back_to_task if @task.update(estimation_create_params)
  end

  def accept
    result = AcceptSelectedEstimation.call(task: @task, user: current_user, commentable: @task,
                                      comment_params: {content: '', parent: @parent}, comment_type: :acceptance)
    # result = AcceptEstimation.call(task: @task)
    redirect_back_to_task if result.success?
  end

  def reject
    result = RejectSelectedEstimation.call(task: @task, user: current_user, commentable: @task, parent: @parent,
                                     comment_params: {content: '', parent: @parent}, comment_type: :rejection)
    # result = RejectEstimation.call(task: @task)
    redirect_back_to_task if result.success?
  end

  # GET groups/:group_id/tasks/:task_id/estimate/pause
  def prompt_pause; end

  # POST groups/:group_id/tasks/:task_id/estimate/pause
  def pause
    result = PauseSelectedTask.call(task_params: estimation_pause_params_task,
                                    comment_params: estimation_pause_params_comment,
                                    commentable: @task,
                                    task: @task,
                                    user: current_user)
    respond_to do |format|
      if result.success?
        format.html { redirect_back(fallback_location: @task) }
        format.json { head :no_content }
        format.js { render 'estimation/reload_timer' }
      end
    end
  end

  # POST groups/:group_id/tasks/:task_id/estimate/resume
  def resume
    resuming = ResumeTask.call(task: @task)
    if resuming.success?
      params[:resume] = ""
      respond_to do |format|
        format.html { redirect_back(fallback_location: @task) }
        format.json { head :no_content }
        format.js { render 'estimation/reload_timer' }
      end
    end
  end

  def stop
    if @task.update(status: :finished)
      respond_to do |format|
        format.html { redirect_back(fallback_location: @task) }
        format.json { head :no_content }
        format.js { render 'estimation/reload_timer' }
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

  def find_last_postpone_comment
    @parent = Comment.last_postpone_comment(@task)
  end

  def estimation_create_params
    params.require(:task).permit(:expires_at, :status)
  end

  def estimation_pause_params_task
    params.require(:estimation).permit(:new_expires_at) if params[:estimation].present?
  end

  def estimation_pause_params_comment
    params.require(:estimation).permit(:content, :new_expires_at) if params[:estimation].present?
  end

end
