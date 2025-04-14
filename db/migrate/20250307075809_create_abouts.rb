class CreateAbouts < ActiveRecord::Migration[7.1]
  def change
    create_table :abouts do |t|
      t.string :community_time
      t.text :description
      t.string :email
      t.string :phone
      t.string :address
      t.string :contact_us_time
      t.string :map_url

      t.timestamps
    end
  end
end
