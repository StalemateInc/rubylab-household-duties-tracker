class AcceptEstimation < BaseInteractor

  def call
    params = { status: :in_progress }
    @saved_task = context.task
    if context.task.new_expires_at
      params[:expires_at] = context.task.new_expires_at
      params[:new_expires_at] = nil
    end
    fail_with_message('estimation acceptance', context.task) unless context.task.update(params)
  end

end