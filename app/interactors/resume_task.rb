class ResumeTask < BaseInteractor

  def call
    date_with_pause_offset = context.task.expires_at + (Time.now - context.task.updated_at)
    params = { expires_at: date_with_pause_offset, status: :in_progress }
    fail_with_message('resuming', context.task) unless context.task.update(params)
  end
end