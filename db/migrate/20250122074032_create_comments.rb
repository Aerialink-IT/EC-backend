class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :review, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :parent_comment, foreign_key: { to_table: :comments }, null: true
      t.text :content

      t.timestamps
    end
  end
end
