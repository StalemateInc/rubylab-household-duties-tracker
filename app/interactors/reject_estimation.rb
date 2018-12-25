class RejectEstimation
  include Interactor

  def call
    params = {}
    if context.task.new_expires_at
      params[:new_expires_at] = nil
      params[:status] = :in_progress
      context.action = "reject initial etimation"
    else
      params[:expires_at] = nil
      params[:status] = :opened
      context.action = "reject pause estimation"
    end
    unless context.task.update(params)
      context.fail!(message: "Failed to #{context.action} for task №#{task.id}!")
    end
  end
end