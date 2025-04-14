class CreateVirtualRoomItems < ActiveRecord::Migration[7.1]
  def change
    create_table :virtual_room_items do |t|
      t.references :virtual_room, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.jsonb :position_data
      t.jsonb :rotation_data

      t.timestamps
    end
  end
end
