class ResumeTask
  include Interactor

  def call
    date_with_pause_offset = context.task.expires_at + (Time.now - context.task.updated_at)
    params = ActionController::Parameters.new(expires_at: date_with_pause_offset, status: :in_progress).permit!
    unless context.task.update(params)
      context.fail!(message: 'Failed to resume the task!')
    end
  end
end