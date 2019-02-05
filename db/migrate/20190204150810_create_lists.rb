class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :title
      t.integer :created_by, index: true
      t.timestamps
    end
  end
end
