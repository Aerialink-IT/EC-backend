class VirtualRoomItem < ApplicationRecord
  belongs_to :virtual_room
  belongs_to :product

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "position_data", "product_id", "rotation_data", "updated_at", "virtual_room_id"]
  end

end
