class RenameRoleToRoleIdInMemberships < ActiveRecord::Migration[5.2]
  def change
    rename_column :memberships, :role, :role_id
  end
end
