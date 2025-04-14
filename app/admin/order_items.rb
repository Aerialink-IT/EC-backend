ActiveAdmin.register OrderItem do
  menu label: proc { I18n.t('active_admin.order_item.title') }
  permit_params :product_id, :order_id, :quantity, :unit_price

  filter :product
  filter :quantity
  filter :unit_price
  filter :total_price
  filter :created_at

  controller do
    def scoped_collection
      super.joins(:order).where.not(orders: { status: Order.statuses[:created] })
    end
  end

  index do
    selectable_column
    id_column
    column I18n.t('active_admin.order_item.product'), :product
    column I18n.t('active_admin.order_item.order'), :order
    column I18n.t('active_admin.order_item.quantity'), :quantity
    column I18n.t('active_admin.order_item.unit_price'), :unit_price
    actions
  end

  form do |f|
    f.inputs I18n.t('active_admin.order_item.details') do
      f.input :product, as: :select, collection: Product.all
      f.input :order, as: :select, collection: Order.all
      f.input :quantity
      if object.product_id
        f.input :unit_price, input_html: { value: (object.quantity * object.product.price), readonly: true }
      end
    end
    f.actions
  end
end
