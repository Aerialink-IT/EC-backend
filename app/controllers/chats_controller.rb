class ChatsController < ApplicationController
  before_action :authenticate_request

  def index
    chats = current_user.chat.includes(:admin)
    render json: chats, each_serializer: ChatSerializer
  end

  def show
    chat = Chat.find(params[:id])
    messages = chat.messages.order(created_at: :asc)
    render json: chats, each_serializer: ChatSerializer
  end

  def create
    chat = Chat.find_or_create_by(user_id: current_user.id, admin_id: Admin.first.id)
    render json: chats, each_serializer: ChatSerializer
  end
end
