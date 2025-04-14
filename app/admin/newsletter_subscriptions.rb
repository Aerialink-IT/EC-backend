ActiveAdmin.register NewsletterSubscription do

  permit_params :email, :subscription_enabled
  actions :all, except: [:new]
  
  index do
    selectable_column
    id_column
    column :email
    column :subscription_enabled
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :subscription_enabled
    end
    f.actions
  end
  
end
