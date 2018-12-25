class PauseTask
  include Interactor

  def call
    context.task_params[:status] = :paused
    unless context.task.update(context.task_params)
      context.fail!(message: 'Failed to pause selected task!')
    end
  end

  def rollback
    context.task.update(status: :in_progress, new_expires_at: nil)
  end
end