class CommentsController < ApplicationController

  before_action :set_commentable
  before_action :set_comment, only: %i[edit update destroy reply]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
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
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @commentable }
      format.json { head :no_content }
      format.js
    end
  end

  def reply
    @reply = @commentable.comments.build(parent: @comment)
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_commentable
    @commentable = Task.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
