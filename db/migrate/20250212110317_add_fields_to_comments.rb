class AddFieldsToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :name, :string
    add_column :comments, :email, :string
    add_column :comments, :title, :string
    add_column :comments, :approved, :boolean, default: false
  end
end
