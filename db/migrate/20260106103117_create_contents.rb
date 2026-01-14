class CreateContents < ActiveRecord::Migration[7.1]
  def change
    create_table :contents do |t|
      t.string :key
      t.text :content_en
      t.text :content_ja
      t.string :section
      t.text :description

      t.timestamps
    end
    add_index :contents, :key, unique: true
    add_index :contents, :section
  end
end
