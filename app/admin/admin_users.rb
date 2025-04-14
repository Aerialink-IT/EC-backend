ActiveAdmin.register AdminUser do
  menu priority: 3, label: proc { I18n.t('active_admin.admin_user.title') }
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column I18n.t('active_admin.admin_user.email'), :email
    column I18n.t('active_admin.admin_user.current_sign_in_at'), :current_sign_in_at
    column I18n.t('active_admin.admin_user.sign_in_count'), :sign_in_count
    column I18n.t('active_admin.admin_user.created_at'), :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs I18n.t('active_admin.admin_user.details') do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
