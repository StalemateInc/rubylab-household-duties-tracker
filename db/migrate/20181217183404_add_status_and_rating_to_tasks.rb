class AddStatusAndRatingToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, "rating", :integer, limit: 1, default: 0
    add_column :tasks, "status", :integer, default: 0
  end
end
