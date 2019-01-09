class RenameProfilePicturePathToAvatar < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :profile_picture_path, :avatar
  end
end
