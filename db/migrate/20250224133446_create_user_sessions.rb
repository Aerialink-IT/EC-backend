class CreateUserSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :user_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :device_name
      t.string :ip_address
      t.string :token
      t.datetime :expires_at
      t.datetime :last_active_at

      t.timestamps
    end
  end
end
