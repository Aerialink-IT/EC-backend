ActiveAdmin.register Category do
  menu priority: 4, label: proc { I18n.t('active_admin.category.title') }
  permit_params :name, :description, :name_jp, :description_jp, :image

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :name_jp
    column :description_jp
    column :created_at
    column do |category|
      if category.image.attached?
        image_tag category.image, size: '100x100'
      else
        "No Image"
      end
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :name_jp
      row :description_jp
      row :created_at
      row :updated_at
      row do |category|
        if category.image.attached?
          image_tag category.image, size: '100x100'
        else
          "No Image"
        end
      end
    end
  end

  form do |f|
    f.inputs I18n.t('active_admin.category.details') do
      f.input :name
      f.input :description
      f.input :name_jp, label: "Name (Japanese)"
      f.input :description_jp, label: "Description (Japanese)"
      f.input :image, as: :file
    end
    f.actions
  end

  filter :name
  filter :description
  filter :name_jp, label: "名前 (Japanese Name)"
  filter :description_jp, label: "説明 (Japanese Description)"
  filter :created_at
  filter :updated_at
end
