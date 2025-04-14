class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.references :user, null: false, foreign_key: true
      t.references :admin_user, null: false, foreign_key: true
      t.boolean :unread_messages

      t.timestamps
    end
  end
end
