ActiveAdmin.register About do
  # actions :all, except: [:new] if About.exists?
  config.clear_action_items!

  config.filters = false
  permit_params :community_time, :description, :email, :phone, :address, :contact_us_time, :map_url, images: []

  action_item :new, only: :index do
    unless About.exists?
      link_to "New About", new_admin_about_path
    end
  end

  form do |f|
    f.inputs 'Business Hours' do
      f.input :community_time
      f.input :description
      f.input :email
      f.input :phone
      f.input :address
      f.input :contact_us_time
      f.input :map_url
      f.input :images, as: :file, input_html: { multiple: true }
    end
    f.actions
  end
end
