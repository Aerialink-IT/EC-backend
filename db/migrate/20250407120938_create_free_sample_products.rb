class CreateFreeSampleProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :free_sample_products do |t|
      t.references :free_samples_request, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
