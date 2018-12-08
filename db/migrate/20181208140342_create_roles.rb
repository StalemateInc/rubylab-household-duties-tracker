class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|

      t.timestamps
    end

    add_column :memberships, :role_id, :integer
  end
end
