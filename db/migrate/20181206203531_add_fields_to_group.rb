class AddFieldsToGroup < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :password, :string, default: ""
    add_column :groups, :visible_to_all, :boolean, default: false
  end
end
