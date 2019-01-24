class ChangeEmailToBeUnique < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :email, :string, unique: true
    change_column :users, :display_name, :string, default: 'Unnamed User'
  end
end
