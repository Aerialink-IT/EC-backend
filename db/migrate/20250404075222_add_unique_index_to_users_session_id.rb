class AddUniqueIndexToUsersSessionId < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :session_id, unique: true, where: "session_id IS NOT NULL"
  end
end
