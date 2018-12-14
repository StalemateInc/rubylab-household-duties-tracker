class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.interval :ttc
      t.references :creator
      t.references :executor
      t.references :group

      t.timestamps
    end

  end
end
