class AddJapaneseFieldsToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :name_jp, :string
    add_column :categories, :description_jp, :string
  end
end
