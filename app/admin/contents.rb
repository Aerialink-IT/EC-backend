ActiveAdmin.register Content do
  menu priority: 2, label: "Content Management"
  
  permit_params :key, :content_en, :content_ja, :section, :description, :image
  
  # Scopes for grouping by section/pages
  scope :all, default: true, show_count: true
  scope :header, show_count: true do |contents|
    contents.where(section: 'header')
  end
  scope :footer, show_count: true do |contents|
    contents.where(section: 'footer')
  end
  scope :home, show_count: true do |contents|
    contents.where(section: 'home')
  end
  scope :about_us, show_count: true do |contents|
    contents.where(section: 'about_us')
  end
  scope :community_forum, show_count: true do |contents|
    contents.where(section: 'community_forum')
  end
  scope :virtual_showroom, show_count: true do |contents|
    contents.where(section: 'virtual_showroom')
  end
  scope :auth, show_count: true do |contents|
    contents.where(section: 'auth')
  end
  scope :cart, show_count: true do |contents|
    contents.where(section: 'cart')
  end
  scope :profile, show_count: true do |contents|
    contents.where(section: 'profile')
  end
  scope :points_management, show_count: true do |contents|
    contents.where(section: 'points_management')
  end
  scope :wishlist, show_count: true do |contents|
    contents.where(section: 'wishlist')
  end
  scope :faq, show_count: true do |contents|
    contents.where(section: 'faq')
  end
  scope :instructions, show_count: true do |contents|
    contents.where(section: 'instructions')
  end
  scope :shipping, show_count: true do |contents|
    contents.where(section: 'shipping')
  end
  scope :product_detail, show_count: true do |contents|
    contents.where(section: 'product_detail')
  end
  scope :sidebar, show_count: true do |contents|
    contents.where(section: 'sidebar')
  end
  scope :other, show_count: true do |contents|
    contents.where(section: 'other')
  end
  
  # Group index by section with better organization
  index do
    selectable_column
    id_column
    column :key do |content|
      link_to content.key, admin_content_path(content)
    end
    column :section do |content|
      status_tag content.section.humanize, class: "section-#{content.section}"
    end
    column :description
    column "English" do |content|
      if content.content_en.present?
        div truncate(content.content_en, length: 50), title: content.content_en
      else
        span "—", class: "empty"
      end
    end
    column "Japanese" do |content|
      if content.content_ja.present?
        div truncate(content.content_ja, length: 50), title: content.content_ja
      else
        span "—", class: "empty"
      end
    end
    column :updated_at do |content|
      content.updated_at.strftime("%Y-%m-%d %H:%M")
    end
    actions
  end
  
  # Enhanced filters
  filter :key
  filter :section, as: :select, collection: [
    ['Header', 'header'],
    ['Footer', 'footer'],
    ['Home', 'home'],
    ['About Us', 'about_us'],
    ['Community Forum', 'community_forum'],
    ['Virtual Showroom', 'virtual_showroom'],
    ['Auth', 'auth'],
    ['Cart', 'cart'],
    ['Profile', 'profile'],
    ['Points Management', 'points_management'],
    ['Wishlist', 'wishlist'],
    ['FAQ', 'faq'],
    ['Instructions', 'instructions'],
    ['Shipping', 'shipping'],
    ['Product Detail', 'product_detail'],
    ['Sidebar', 'sidebar'],
    ['Other', 'other']
  ]
  filter :description
  filter :content_en
  filter :content_ja
  filter :created_at
  filter :updated_at
  
  form do |f|
    f.inputs "Content Details" do
      f.input :key, hint: "Unique key identifier (e.g., 'footer.title', 'header.home')"
      f.input :section, as: :select, collection: [
        ['Header', 'header'],
        ['Footer', 'footer'],
        ['Home', 'home'],
        ['About Us', 'about_us'],
        ['Community Forum', 'community_forum'],
        ['Virtual Showroom', 'virtual_showroom'],
        ['Auth/Login/Register', 'auth'],
        ['Cart', 'cart'],
        ['Profile', 'profile'],
        ['Points Management', 'points_management'],
        ['Wishlist', 'wishlist'],
        ['FAQ', 'faq'],
        ['Instructions', 'instructions'],
        ['Shipping', 'shipping'],
        ['Product Detail', 'product_detail'],
        ['Sidebar', 'sidebar'],
        ['Other', 'other']
      ], hint: "Section where this content is used"
      f.input :description, hint: "Description of what this content is for"
    end
    
    # Check if this is an image upload field (home page banner images, sidebar gallery images, or about us images)
    is_image_field = f.object.key&.start_with?('home.banner_image', 'home.second_banner_image', 'sidebar.gallery_image_', 'about_us.banner_image', 'about_us.product_image', 'about_us.map_image', 'about_us.gallery_image_')
    
    # Check if this is a URL field (YouTube link only)
    is_url_field = f.object.key&.start_with?('sidebar.youtube_link')
    
    if is_image_field
      f.inputs "Image Upload" do
        f.input :image, 
          as: :file, 
          hint: f.object.image.attached? ? image_tag(f.object.image, size: "200x200") : "Upload an image file (JPG, PNG, etc.)"
        f.input :content_en, 
          as: :string, 
          label: "Or enter image URL (optional)",
          hint: "Leave empty to use uploaded image, or enter URL to override uploaded image"
      end
    elsif is_url_field
      f.inputs "URL" do
        f.input :content_en, 
          as: :url, 
          label: "URL",
          hint: "Enter the full URL (e.g., https://www.youtube.com/watch?v=VIDEO_ID or https://example.com/image.jpg). For sidebar images/links, use English field only."
      end
    else
      f.inputs "English Content" do
        f.input :content_en, as: :text, input_html: { rows: 5 }, hint: "English version of the content"
      end
      
      f.inputs "Japanese Content" do
        f.input :content_ja, as: :text, input_html: { rows: 5 }, hint: "Japanese version of the content"
      end
    end
    
    f.actions
  end
  
  show do |content_record|
    is_image_field = content_record.key&.start_with?('home.banner_image', 'home.second_banner_image', 'sidebar.gallery_image_', 'about_us.banner_image', 'about_us.product_image', 'about_us.map_image', 'about_us.gallery_image_')
    is_url_field = content_record.key&.start_with?('sidebar.youtube_link')
    
    attributes_table do
      row :id
      row :key
      row :section
      row :description
      if is_image_field
        row "Image" do
          if content_record.image.attached?
            div do
              image_tag content_record.image, size: "300x300"
              br
              link_to "View Full Size", rails_blob_path(content_record.image, disposition: "attachment"), target: "_blank", class: "button"
            end
          elsif content_record.content_en.present?
            div do
              "URL: #{content_record.content_en}"
              br
              link_to "Open URL", content_record.content_en, target: "_blank", class: "button"
            end
          else
            span "No image uploaded", class: "empty"
          end
        end
      elsif is_url_field
        row "URL" do
          if content_record.content_en.present?
            div do
              content_record.content_en
              br
              link_to "Open Link", content_record.content_en, target: "_blank", class: "button"
            end
          else
            span "Not set", class: "empty"
          end
        end
      else
        row "English Content" do
          content_record.content_en
        end
        row "Japanese Content" do
          content_record.content_ja
        end
      end
      row :created_at
      row :updated_at
    end
  end
end

