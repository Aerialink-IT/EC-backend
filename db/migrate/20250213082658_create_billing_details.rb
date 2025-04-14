class CreateBillingDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :billing_details do |t|
      t.string :full_name
      t.string :phone_number
      t.string :street_address
      t.string :postal_code
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
