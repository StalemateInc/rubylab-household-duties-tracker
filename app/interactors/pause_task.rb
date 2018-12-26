class PauseTask
  include Interactor

  def call
    if context.task_params.nil?
      context.task_params = ActionController::Parameters.new(status: :paused).permit!
    else
      context.task_params[:new_created_at] = Time.parse(context.task_params[:new_created_at]).utc.to_s
      context.task_params[:status] = :paused
    end
    unless context.task.update(context.task_params)
      context.fail!(message: 'Failed to pause selected task!')
    end
  end

  def rollback
    context.task.update(status: :in_progress, new_expires_at: nil)
  end
end