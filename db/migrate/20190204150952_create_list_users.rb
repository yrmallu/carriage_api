class CreateListUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :list_users do |t|
      t.references :user, foreign_key: true, index: true
      t.references :list, foreign_key: true, index: true

      t.timestamps
    end
  end
end
