class RenameColumnsInRoles < ActiveRecord::Migration[5.2]
  def change
    remove_column :roles, :role
    add_column :roles, :text_name, :string
  end
end
