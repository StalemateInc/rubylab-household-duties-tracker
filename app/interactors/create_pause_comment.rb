class CreatePauseComment
  include Interactor

  AUTOMATIC_COMMENT_TEMPLATE = '[AUTO]: %user% requested postponement till %until%. Reason: "%reason%"'

  def call
    unless context.comment_params.nil? || context.comment_params.empty?
      unless context.comment_params[:new_expires_at].nil?
        new_expired_at = Time.parse(context.comment_params.delete(:new_expires_at)).utc.to_s
        comment = context.task.comments.build(context.comment_params)
        replacements = { "%user%": context.user.display_name,
                         "%until%": new_expired_at, "%reason%": comment.content }
        comment.content = AUTOMATIC_COMMENT_TEMPLATE.clone
        replacements.each { |before, after| comment.content.gsub!(before.to_s, after) }
        comment.user = context.user
        unless comment.save
          context.fail!(message: 'Failed to generate automatic comment on task!')
        end
      end
    end
  end

end