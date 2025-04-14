class CreateDescriptionImages < ActiveRecord::Migration[7.1]
  def change
    create_table :description_images do |t|
      t.references :product, null: false, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
