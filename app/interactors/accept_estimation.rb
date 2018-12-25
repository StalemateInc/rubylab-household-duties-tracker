class AcceptEstimation
  include Interactor

  def call
    params = {}
    if context.task.new_expires_at
      params[:expires_at] = context.task.new_expires_at
      params[:new_expires_at] = nil
    end
    params[:status] = :in_progress
    unless context.task.update(params)
      context.fail!(message: "Failed to accept estimation for task №#{task.id}!")
    end
  end
end