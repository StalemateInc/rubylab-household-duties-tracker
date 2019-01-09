class AddNewExpiresAtToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :new_expires_at, :timestamp
  end
end
