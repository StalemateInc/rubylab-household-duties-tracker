class CommentsController < ApplicationController

  before_action :find_commentable
  before_action :find_comment, only: %i[edit update destroy reply]

  def create
    result = CreateComment.call(comment_params: comment_params, commentable: @commentable, user: current_user)
    success = result.success?
    @comment = result.comment
    respond_to do |format|
      if success
        format.html { redirect_to @commentable }
        format.json { render json: @comment }
      else
        format.html { redirect_back(fallback_location: @commentable) }
      end
      format.js
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @commentable }
        format.json { render json: @comment }
      else
        format.html { redirect_back(fallback_location: @commentable) }
      end
      format.js
    end
  end

  def destroy
    respond_to do |format|
      if @comment.destroy
        format.html { redirect_to @commentable }
        format.json { head :no_content }
        format.js
      end
    end
  end

  def reply
    @reply = @commentable.comments.build(parent: @comment)
  end

  private

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def find_commentable
    @commentable = Task.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
