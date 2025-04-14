class MessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :sender_type, :sender_id, :chat_id, :read, :created_at

  belongs_to :chat
end
