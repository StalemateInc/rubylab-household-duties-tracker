class AddPostponeToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :postpone, :boolean, default: false
  end
end
