class AddDetailsToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :instructions, :text
    add_column :products, :colors, :jsonb, default: []
    add_column :products, :sizes, :jsonb, default: []
    add_column :products, :weight, :string
  end
end
