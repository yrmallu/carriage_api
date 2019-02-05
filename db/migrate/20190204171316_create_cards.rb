class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :title
      t.text :description
      t.references :list, index: true
      t.integer :created_by, index: true

      t.timestamps
    end
  end
end
