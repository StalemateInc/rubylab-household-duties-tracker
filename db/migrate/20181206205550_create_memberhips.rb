class CreateMemberhips < ActiveRecord::Migration[5.2]
  def change
    create_table :memberhips do |t|
      t.integer :role

      t.timestamps
    end
  end
end
