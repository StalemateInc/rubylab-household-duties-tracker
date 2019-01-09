class TaskPresenter < BasePresenter
  include ActionView::Helpers::DateHelper
  def creator_name
    @model.creator.display_name
  end

  def executor_name
    @model.executor.display_name
  end

  def creator_with_email
    creator = @model.creator
    "#{creator.display_name}<#{creator.email}>"
  end

  def executor_with_email
    executor = @model.executor
    "#{executor.display_name}<#{executor.email}>"
  end

  def comment_count
    @model.comments.count
  end

  def formatted_expires_at(timezone)
    format_date(@model.expires_at, timezone)
  end

  def formatted_new_expires_at(timezone)
    format_date(@model.new_expires_at, timezone)
  end

  def between_expires_at_and_now
    distance_of_time_in_words(@model.expires_at, Time.now.utc, locale: I18n.locale)
  end

  def between_new_expires_at_and_expires_at
    distance_of_time_in_words(@model.new_expires_at, @model.expires_at, locale: I18n.locale)
  end

  def got_initial_estimate?
    @model.pending? && h.can?(:start, @model)
  end

  def got_additional_estimate?
    @model.paused? && @model.new_expires_at && h.can?(:start, @model)
  end

  private

  def format_date(date, timezone)
    date.in_time_zone(timezone).strftime('%Y-%m-%d %H:%M:%S')
  end

end