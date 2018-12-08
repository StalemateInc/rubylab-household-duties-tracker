class AddColumnsToMembership < ActiveRecord::Migration[5.2]
  def change
    add_column :memberhips, :user_id, :integer
    add_column :memberhips, :group_id, :integer
  end
end
