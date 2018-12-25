class CreatePauseComment
  include Interactor

  AUTOMATIC_COMMENT_TEMPLATE = '[AUTO]: %user% requested postponement till %until%. Reason: "%reason%"'

  def call
    new_expired_at = context.comment_params.delete('new_expires_at')
    comment = context.task.comments.build(context.comment_params)
    replacements = { "%user%": context.user.display_name,
                     "%until%": new_expired_at, "%reason%": comment.content }
    comment.content = AUTOMATIC_COMMENT_TEMPLATE
    replacements.each { |before, after| comment.content.gsub!(before.to_s, after) }
    comment.user = context.user
    unless comment.save
      context.fail!(message: 'Failed to generate automatic comment on task!')
    end
  end

end