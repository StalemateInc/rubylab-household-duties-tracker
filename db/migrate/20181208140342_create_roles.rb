class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.integer :role
      t.string :name
      t.timestamps
    end
  end
end
