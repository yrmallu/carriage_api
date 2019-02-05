class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :content
      t.references :card, index: true
      t.integer :created_by, index: true
      t.integer :parent_comment_id, index: true
      t.integer :comment_type, index: true

      t.timestamps
    end
  end
end
