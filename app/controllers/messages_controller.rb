class MessagesController < ApplicationController
  before_action :authenticate_request

  def index
    user = current_user
    admin = AdminUser.first

    return render json: { error: "Admin not found" }, status: :not_found unless admin
    chat = Chat.find_by(user: user, admin_user: admin)

    return render json: { error: "No chat found" }, status: :not_found unless chat
    messages = chat.messages.order(created_at: :asc)

    render json: {
      success: true,
      chat: {
        id: chat.id,
        messages: messages.map { |msg| format_message(msg) }
      }
    }, status: :ok
  end

  def create
    admin = AdminUser.first
    user = current_user

    return render json: { error: "Admin not found" }, status: :not_found unless admin
    chat = Chat.find_or_create_by(user: user, admin_user: admin)
    message = chat.messages.build(message_params.merge(sender: user))

    if message.save
      chat.update(unread_messages: true)
      render json: {
        success: true,
        chat: {
          id: chat.id,
          messages: chat.messages.order(created_at: :asc).map { |msg| format_message(msg) }
        }
      }, status: :created
    else
      render json: { error: message.errors.full_messages }, status: :unprocessable_entity
    end
  end
  private

  def message_params
    params.require(:message).permit(:content)
  end

  def format_message(msg)
    {
      id: msg.id,
      content: msg.content,
      sender_type: msg.sender_type,
      sender_id: msg.sender_id,
      created_at: msg.created_at
    }
  end
end
