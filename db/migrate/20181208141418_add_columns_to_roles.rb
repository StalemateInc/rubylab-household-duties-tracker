class AddColumnsToRoles < ActiveRecord::Migration[5.2]
  def changes
    add_column :roles, :role, :integer
  end
end
