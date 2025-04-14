class AddUuidToProductsAndCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_index :products, :uuid, unique: true
    add_column :categories, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_index :categories, :uuid, unique: true
  end
end
