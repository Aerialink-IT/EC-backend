class CreateProductSizes < ActiveRecord::Migration[7.1]
  def change
    create_table :product_sizes do |t|
      t.references :product, null: false, foreign_key: true
      t.string :size
      t.decimal :price

      t.timestamps
    end
  end
end
