class AddSessionIdAndGuestUserToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :session_id, :string
    add_column :users, :guest_user, :boolean, default: false
  end
end
