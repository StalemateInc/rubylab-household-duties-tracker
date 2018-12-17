class AddVisibleToAllColumnToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, 'visible_to_all', :boolean, default: false, null: false
  end
end
