class CreateInquiryForms < ActiveRecord::Migration[7.1]
  def change
    create_table :inquiry_forms do |t|
      t.string :full_name
      t.string :email
      t.string :phone_number
      t.string :order_number
      t.text :message
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
