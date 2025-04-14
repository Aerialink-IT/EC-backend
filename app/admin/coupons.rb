ActiveAdmin.register Coupon do
  menu priority: 5, label: proc { I18n.t('active_admin.coupon.title') }
  permit_params :name, :code, :discount_type, :discount_value, :user_id, :status, :coupon_type, :valid_from, :valid_until

  form do |f|
    f.inputs I18n.t('active_admin.coupon.details') do
      f.input :code
      f.input :name
      if f.object.new_record?
        f.input :coupon_type, as: :hidden, input_html: { value: 'member_specific' }
      else
        f.input :coupon_type, input_html: { disabled: true }
      end
      f.input :discount_type
      f.input :discount_value
      f.input :user, as: :select, collection: User.all
      f.input :status
      f.input :valid_from, as: :datepicker
      f.input :valid_until, as: :datepicker
    end
    f.actions
  end

  filter :name
  filter :code
  filter :coupon_type
  filter :status
  filter :product
end
