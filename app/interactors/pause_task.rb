class PauseTask < BaseInteractor

  def call
    if context.task_params.nil? || context.task_params.empty?
      context.task_params = { status: :paused }
    else
      context.task_params[:new_expires_at] = Time.parse(context.task_params[:new_expires_at]).utc.iso8601
      context.task_params[:status] = :paused
    end
    fail_with_message('pausing', context.task) unless context.task.update(context.task_params)
  end

  def rollback
    context.task.update(status: :in_progress, new_expires_at: nil)
  end
end