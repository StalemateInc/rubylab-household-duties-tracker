class CreateComment < BaseInteractor

  def call
    if context.comment_params.presence || !context.comment_params.blank?
      expiration_date = context.comment_params.delete(:new_expires_at)
      comment = context.commentable.comments.build(context.comment_params)
      comment.postpone = expiration_date.present?
      comment.user = context.user
      comment.save ? context.comment = comment : fail_with_message('automatic comment generation', comment)
    end
  end
end
