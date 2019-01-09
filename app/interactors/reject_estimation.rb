class RejectEstimation < BaseInteractor

  def call
    params = {}
    if context.task.new_expires_at
      params[:new_expires_at] = nil
      params[:status] = :in_progress
      context.action = 'rejection of initial estimation'
    else
      params[:expires_at] = nil
      params[:status] = :opened
      context.action = 'rejection of pause estimation'
    end
    fail_with_message(context.action, context.task) unless context.task.update(params)
  end
end