class CreateRoomImages < ActiveRecord::Migration[7.1]
  def change
    create_table :room_images do |t|
      t.references :virtual_room, null: false, foreign_key: true
      t.string :image_url
      t.datetime :uploaded_at

      t.timestamps
    end
  end
end
