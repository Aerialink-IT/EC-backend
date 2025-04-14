ActiveAdmin.register Product do
  permit_params :name, :stock_quantity, :price, :description, :is_active, :instructions, :colors, :sizes, :weight, :product_size, :virtual_image, images: [], category_ids: [], description_images_attributes: [:id, :image, :description, :_destroy], product_sizes_attributes: [:id, :size, :price, :_destroy]

  index do
    selectable_column
    id_column
    column I18n.t('active_admin.product.name'), :name
    column I18n.t('active_admin.product.categories') do |product|
      product.categories.map(&:name).join(', ')
    end
    column I18n.t('active_admin.product.price'), :price
    column I18n.t('active_admin.product.stock_quantity'), :stock_quantity
    column I18n.t('active_admin.product.is_active'), :is_active
    column I18n.t('active_admin.product.images') do |product|
      if product.images.attached?
        image_tag product.images.first, size: '100x100'
      else
        I18n.t('active_admin.product.no_images')
      end
    end
    column I18n.t('active_admin.product.created_at'), :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :stock_quantity
      row :is_active
      row :product_size
      row :instructions
      row :colors
      row :sizes
      row :weight
      row :created_at
      row :updated_at
      panel "Product Sizes" do
        table_for product.product_sizes do
          column :size
          column :price
        end
      end
      row "Product Images" do
        resource.images.each do |img|
          div style: "display: inline-block; margin-right: 15px;" do
            image_tag img.url, size: "100x100", style: "border-radius: 5px;" if img.url.present?
          end
        end
        nil
      end
      row "Virtual Image" do
        if resource.virtual_image.attached?
          image_tag resource.virtual_image, size: "100x100", style: "border-radius: 5px;"
        else
          "No Virtual Image"
        end
      end
      row "More Description" do
        div style: "display: flex; gap: 20px; flex-wrap: wrap; align-items: flex-start;" do
          product.description_images.each do |desc_img|
            div style: "text-align: center; width: 120px; min-height: 140px; display: flex; flex-direction: column; align-items: center; justify-content: start;" do
              if desc_img.image.present?
                div style: "width: 100px; height: 100px; display: flex; align-items: center; justify-content: center;" do
                  image_tag desc_img.image.url, size: "100x100", style: "border-radius: 5px;"
                end
              end
              if desc_img.description.present?
                div style: "margin-top: 5px; font-size: 12px; color: #333; text-align: center; word-wrap: break-word;" do
                  text_node desc_img.description
                end
              end
            end
          end
        end
      end
    end

    panel "Product QnA" do
      div do
        def render_qna(comments, level = 0)
          comments.each do |comment|
            div style: "margin-top: 5px; border: 1px solid #ddd; padding: 10px; padding-top: 3px; margin-bottom: 10px; margin-left: #{level * 10}px; border-radius: 8px; background: #f9f9f9; position: relative;" do
              div style: "font-weight: bold; font-size: 14px;" do
                text_node comment.content
              end

              div style: "font-size: 12px; color: #333;" do
                text_node "Commenter name: #{comment.user.full_name}"
              end

              div style: "color: gray; font-size: 12px;" do
                text_node "Likes: #{comment.likes_count} | Dislikes: #{comment.dislikes_count} | Posted: #{comment.created_at.strftime('%b %d, %Y %H:%M')}"
              end

              unless comment.approved?
                div style: "position: absolute; top: 15px; right: 15px;" do
                  link_to "Approve",
                          approve_admin_comment_path(comment),
                          method: :put,
                          remote: true,
                          class: "approve-comment-btn",
                          data: { id: comment.id },
                          style: "padding: 6px 12px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; text-decoration: none;"
                end
              end

              child_comments = comment.child_comments.order(created_at: :asc)
              render_qna(child_comments, level + 1) if child_comments.any?
            end
          end
        end

        parent_comments = product.comments.where(parent_comment_id: nil).includes(:child_comments, child_comments: :user).order(created_at: :desc)
        render_qna(parent_comments)
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :instructions
      f.input :price
      f.input :stock_quantity
      f.input :colors, as: :string, input_html: { class: 'tags-input', value: f.object.colors.is_a?(Array) ? f.object.colors.join(', ') : f.object.colors }, hint: 'Enter colors separated by commas.'
      f.input :sizes, as: :string, input_html: { class: 'tags-input', value: f.object.sizes.is_a?(Array) ? f.object.sizes.join(', ') : f.object.sizes }, hint: 'Enter sizes separated by commas.'
      f.input :weight, hint: 'Enter weight in format like 800g/piece.'
      f.input :product_size
      f.input :is_active
    end
    f.inputs 'Product Sizes' do
      f.has_many :product_sizes, allow_destroy: true, new_record: true do |p|
        p.input :size
        p.input :price
      end
    end
    f.inputs "Upload Virtual Image" do
      f.input :virtual_image, as: :file
      if f.object.virtual_image.attached?
        div do
          image_tag f.object.virtual_image, size: "200x200", style: "border-radius: 5px;"
        end
      end
    end
    f.inputs do
      f.has_many :description_images, allow_destroy: true, new_record: true do |di|
        di.input :image, as: :file
        di.input :description
      end
      f.semantic_errors :description_images
    end
    f.inputs I18n.t('active_admin.product.categories') do
      f.input :category_ids, as: :check_boxes, collection: Category.all
      f.semantic_errors :product_categories
    end
    f.inputs "Product Images" do
      f.input :images, as: :file, input_html: { multiple: true }, hint: "Leave empty to keep existing images."
    
      if f.object.images.attached?
        div style: "display: flex; gap: 10px; margin-top: 10px;" do
          f.object.images.each do |image|
            div do
              image_tag url_for(image), size: "100x100", style: "border-radius: 5px; border: 1px solid #ddd;"
            end
          end
        end
      end
    end

    f.actions
  end

  filter :name
  filter :price
  filter :stock_quantity
  filter :is_active
  filter :created_at
  filter :updated_at

  controller do
    def update
      product = Product.find(params[:id])
      if params[:images].blank?
        params[:product].delete(:images)
      end
  
      super
    end
  end
end
