ActiveAdmin.register FreeSamplesRequest do
  menu priority: 5, label: 'Free Sample Requests'
  permit_params :user_id, :delivery_address_id, :email, product_ids: []

  includes :user, :delivery_address, :products

  actions :index, :show, :destroy

  # filter :user, as: :select, collection: User.all.collect { |u| ["#{u.first_name} #{u.last_name}", u.id] }
  filter :user, as: :select, collection: proc {
    User.all.collect { |u| ["#{u.first_name} #{u.last_name}", u.id] }
  }
  filter :created_at

  index do
    selectable_column
    id_column
    column :user
    column :email
    column :delivery_address
    column("Products") { |fsr| fsr.products.map(&:name).join(", ") }
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :user
      row :delivery_address
      row :created_at
      row :updated_at
    end

    panel "Requested Products" do
      table_for resource.products do
        column "Image" do |product|
          if product.images.attached?
            image_tag url_for(product.images.first), size: "100x100"
          else
            status_tag "No Image"
          end
        end
        column :name
        column :description
        column :price
      end
    end
  end

end
