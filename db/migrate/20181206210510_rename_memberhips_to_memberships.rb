class RenameMemberhipsToMemberships < ActiveRecord::Migration[5.2]
  def change
    rename_table :memberhips, :memberships
  end
end
