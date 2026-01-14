ActiveAdmin.register SidebarContent do
  menu priority: 3, label: "Sidebar Content"
  
  permit_params :youtube_link, :gallery_image_1, :gallery_image_2, :gallery_image_3, :gallery_image_4, :gallery_image_5

  # Only allow one sidebar content record
  config.filters = false
  
  controller do
    def index
      @sidebar_content = SidebarContent.first || SidebarContent.create!
      redirect_to admin_sidebar_content_path(@sidebar_content)
    end
  end

  index do
    div do
      h3 "Sidebar Content Management"
      para "Manage YouTube video and gallery images for the sidebar. Only one record exists."
    end
  end

  show do
    attributes_table do
      row :youtube_link do |content|
        if content.youtube_link.present?
          div do
            content.youtube_link
            br
            link_to "Open YouTube Link", content.youtube_link, target: "_blank", class: "button"
          end
        else
          span "Not set", class: "empty"
        end
      end
      row :gallery_image_1 do |content|
        if content.gallery_image_1.present?
          div do
            content.gallery_image_1
            br
            link_to "View Image", content.gallery_image_1, target: "_blank", class: "button"
          end
        else
          span "Not set", class: "empty"
        end
      end
      row :gallery_image_2 do |content|
        if content.gallery_image_2.present?
          div do
            content.gallery_image_2
            br
            link_to "View Image", content.gallery_image_2, target: "_blank", class: "button"
          end
        else
          span "Not set", class: "empty"
        end
      end
      row :gallery_image_3 do |content|
        if content.gallery_image_3.present?
          div do
            content.gallery_image_3
            br
            link_to "View Image", content.gallery_image_3, target: "_blank", class: "button"
          end
        else
          span "Not set", class: "empty"
        end
      end
      row :gallery_image_4 do |content|
        if content.gallery_image_4.present?
          div do
            content.gallery_image_4
            br
            link_to "View Image", content.gallery_image_4, target: "_blank", class: "button"
          end
        else
          span "Not set", class: "empty"
        end
      end
      row :gallery_image_5 do |content|
        if content.gallery_image_5.present?
          div do
            content.gallery_image_5
            br
            link_to "View Image", content.gallery_image_5, target: "_blank", class: "button"
          end
        else
          span "Not set", class: "empty"
        end
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Sidebar YouTube & Images" do
      f.input :youtube_link, 
        as: :text, 
        input_html: { rows: 2 },
        hint: "Enter the full YouTube video URL (e.g., https://www.youtube.com/watch?v=VIDEO_ID or https://youtu.be/VIDEO_ID). This video will be displayed in the sidebar."
      
      f.inputs "Gallery Images", class: "inputs" do
        f.input :gallery_image_1, 
          as: :text, 
          input_html: { rows: 2 },
          hint: "Main instruction image URL (links to /instructions page)"
        f.input :gallery_image_2, 
          as: :text, 
          input_html: { rows: 2 },
          hint: "Shipping info image URL (links to /shipping-info page)"
        f.input :gallery_image_3, 
          as: :text, 
          input_html: { rows: 2 },
          hint: "Samples image URL (opens samples modal)"
        f.input :gallery_image_4, 
          as: :text, 
          input_html: { rows: 2 },
          hint: "Gallery image 4 URL (optional)"
        f.input :gallery_image_5, 
          as: :text, 
          input_html: { rows: 2 },
          hint: "Bottom gallery image URL (links to /virtual-showroom page)"
      end
    end
    f.actions
  end
end

