class CreateProduct3DModels < ActiveRecord::Migration[7.1]
  def change
    create_table :product3_d_models do |t|
      t.references :product, null: false, foreign_key: true
      t.string :model_url
      t.string :format
      t.datetime :uploaded_at

      t.timestamps
    end
  end
end
