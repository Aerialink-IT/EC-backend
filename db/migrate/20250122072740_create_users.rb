class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_hash
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.boolean :is_active

      t.timestamps
    end
  end
end
