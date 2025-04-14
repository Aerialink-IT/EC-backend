class CreateDeliveryAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :delivery_addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :line1
      t.string :line2
      t.string :prefecture
      t.string :post_code
      t.string :phone_number
      t.string :email
      t.boolean :status, default: false

      t.timestamps
    end
  end
end
