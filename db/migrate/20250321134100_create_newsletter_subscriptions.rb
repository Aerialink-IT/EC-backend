class CreateNewsletterSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :newsletter_subscriptions do |t|
      t.string :email
      t.boolean :subscription_enabled

      t.timestamps
    end
  end
end
