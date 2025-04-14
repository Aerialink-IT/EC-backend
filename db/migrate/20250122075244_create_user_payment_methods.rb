class CreateUserPaymentMethods < ActiveRecord::Migration[7.1]
  def change
    create_table :user_payment_methods do |t|
      t.references :user, null: false, foreign_key: true
      t.string :payment_type
      t.string :payment_details
      t.boolean :is_default

      t.timestamps
    end
  end
end
