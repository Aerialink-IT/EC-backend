ActiveAdmin.register Chat do
  permit_params :user_id, :admin_user_id, :unread_messages

  actions :all, except: [:edit, :new]

  filter :user
  filter :admin_user
  filter :unread_messages
  filter :created_at

  scope :all, default: true
  scope :unread, -> { Chat.unread }

  index do
    selectable_column
    id_column
    column :user
    column :admin_user
    column :unread_messages do |chat|
      status_tag(chat.unread_messages ? "Yes" : "No", class: chat.unread_messages ? "red" : "green")
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    chat.messages.where(read: false).update_all(read: true)
    chat.update(unread_messages: false)

    attributes_table do
      row :id
      row :user
      row :admin_user
      row :unread_messages
      row :created_at
      row :updated_at
    end

    panel "Messages" do
      table_for chat.messages.order(created_at: :asc) do
        column :sender do |message|
          if message.sender.is_a?(User)
            "<strong>User:</strong> #{message.sender.first_name}".html_safe
          else
            "<strong>User</strong> : Admin".html_safe
          end
        end
        column :content
        column :created_at
      end
    end

    panel "Reply" do
      active_admin_form_for Message.new, url: reply_admin_chat_path(chat), method: :post do |f|
        f.input :content, label: "<strong>Your Reply</strong>".html_safe, input_html: { rows: 5, class: "custom-textarea" }
        f.hidden_field :chat_id, value: chat.id
        f.hidden_field :sender_type, value: "AdminUser"
        f.hidden_field :sender_id, value: current_admin_user.id
        f.actions
      end
    end
  end

  member_action :reply, method: :post do
    chat = Chat.find(params[:id])
    message = chat.messages.create(
      content: params[:message][:content],
      sender: current_admin_user
    )

    if message.persisted?
      redirect_to admin_chat_path(chat), notice: "Reply sent successfully!"
    else
      redirect_to admin_chat_path(chat), alert: "Error sending reply."
    end
  end
end
