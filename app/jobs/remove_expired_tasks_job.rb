class RemoveExpiredTasksJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotSaved) do
    retry_job wait: 5.minutes, queue: :low_priority
  end

  def perform(*args)
    Task.where(['expires_at < ? ', Time.now]).where.not(status: [:finished, :closed])
        .update_all(status: Task.statuses[:finished])
  end
end
