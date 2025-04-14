class CreateFreeSamplesRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :free_samples_requests do |t|
      t.string :email
      t.text :address
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
