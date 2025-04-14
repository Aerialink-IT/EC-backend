ActiveAdmin.register Comment do
  actions :all, except: [:edit, :new]

  member_action :approve, method: :put do
    resource.update!(approved: true)

    respond_to do |format|
      format.html { redirect_to admin_product_path(resource.product), notice: "Comment approved successfully!" }
      format.js
    end
  end

  index do
    selectable_column
    column :id
    column :user_name do |comment|
      comment.user ? comment.user.full_name : comment.name
    end
    column :title
    column :content
    column :product
    column :approved
    column :created_at
    actions
  end

  filter :user
  filter :product
  filter :approved
  filter :created_at
end
