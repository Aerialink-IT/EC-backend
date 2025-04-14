class ChatSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :admin_id, :created_at

  has_many :messages
end