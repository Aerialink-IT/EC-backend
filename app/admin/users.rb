ActiveAdmin.register User do
  menu label: proc { I18n.t('active_admin.user.title') }
  permit_params :first_name, :last_name, :email, :password, :password_confirmation, :phone, :is_active, :profile_image

  index do
    selectable_column
    id_column
    column I18n.t('active_admin.user.username'), :username
    column I18n.t('active_admin.user.email'), :email
    column I18n.t('active_admin.user.first_name'), :first_name
    column I18n.t('active_admin.user.last_name'), :last_name
    column I18n.t('active_admin.user.phone'), :phone
    column I18n.t('active_admin.user.is_active'), :is_active
    column I18n.t('active_admin.user.profile_image') do |user|
      if user.profile_image.attached?
        image_tag user.profile_image, size: '100x100'
      else
        I18n.t('active_admin.user.no_image')
      end
    end
    actions
  end

  controller do
    def show
      @user = User.find(params[:id])  # Ensure you explicitly set @user
      super
    end
  end

  show do
    attributes_table do
      row I18n.t('active_admin.user.username'), user.username
      row I18n.t('active_admin.user.email'), user.email
      row I18n.t('active_admin.user.first_name'), user.first_name
      row I18n.t('active_admin.user.last_name'), user.last_name
      row I18n.t('active_admin.user.phone'), user.phone
      row I18n.t('active_admin.user.is_active'), user.is_active
    end

    panel I18n.t('active_admin.user.profile_image') do
      if user.profile_image.attached?
        image_tag user.profile_image, size: '200x200'
      else
        I18n.t('active_admin.user.no_image')
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :phone
      f.input :password
      f.input :password_confirmation
      f.input :is_active
    end
    f.inputs do
      f.input :profile_image, as: :file
    end
    f.actions
  end

  filter :first_name 
  filter :last_name
  filter :email
  filter :phone
  filter :is_active
  filter :with_profile_image, as: :boolean, label: I18n.t('active_admin.user.has_profile_image')
end
