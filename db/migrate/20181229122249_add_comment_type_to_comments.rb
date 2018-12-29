class AddCommentTypeToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :comment_type, :integer, default: 0
  end
end
