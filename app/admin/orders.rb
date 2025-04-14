ActiveAdmin.register Order do
  menu label: proc { I18n.t('active_admin.order.title') }
  permit_params :user_id, :billing_detail_id, :delivery_address_id, :total_amount, :sub_total,
                :loyalty_points_used, :status, :payment_method, :payment_status, :consumer_tax,
                :shipping, :delivery_fees, :session_id, :reward_points_used, :coupon_amount,
                :coupon_code, order_items_attributes: [:id, :product_id, :size, :quantity, :_destroy]

  # filter :user, as: :select, collection: User.all.collect { |u| ["#{u.first_name} #{u.last_name}", u.id] }
  filter :user, as: :select, collection: proc {
    User.all.collect { |u| ["#{u.first_name} #{u.last_name}", u.id] }
  }
  filter :status, as: :select, collection: Order.statuses.keys
  filter :payment_method, as: :select, collection: Order.payment_methods.keys
  filter :payment_status, as: :select, collection: Order.payment_statuses.keys
  filter :total_amount
  filter :created_at

  action_item :mark_as_delivered, only: :show do
    if resource.status != "delivered"
      link_to "Mark as Delivered", mark_as_delivered_admin_order_path(resource), method: :post, class: "button"
    end
  end

  member_action :mark_as_delivered, method: :post do
    order = Order.find(params[:id])
    if order.present?
      if order.payment_method == "cash_on_delivery"
        success = WebhooksController.new.confirm_delivery(order.id, from_admin: true)
        if success
          redirect_to admin_order_path(order), notice: "Order marked as delivered!"
        else
          redirect_to admin_order_path(order), alert: "Failed to mark order as delivered."
        end
      else
        order.update(status: "delivered", payment_status: "paid")
        redirect_to admin_order_path(order), notice: "Order marked as delivered!"
      end
    else
      redirect_to admin_order_path(order), alert: "Order not found."
    end
  end

  scope :all, default: true
  scope :guest_orders do |orders|
    orders.joins(:user).where(users: { guest_user: true })
  end

  controller do
    def scoped_collection
      super.where.not(status: Order.statuses[:created])
    end
  end


  index do
    selectable_column
    id_column
    column :user
    column :total_amount
    column :loyalty_points_used
    column :status
    column :payment_method
    column :payment_status
    column :coupon_amount
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :total_amount
      row :sub_total
      row :loyalty_points_used
      row :status
      row :payment_method
      row :payment_status
      row :coupon_code
      row :coupon_amount
      row :created_at
      row :updated_at
    end

    panel "Billing Details" do
      attributes_table_for order.billing_detail do
        row :id
        row :full_name
        row :phone_number
        row :street_address
        row :postal_code
      end
    end

    panel "Delivery Details" do
      attributes_table_for order.delivery_address do
        row :first_name
        row :last_name
        row :line1
        row :line2
        row :prefecture
        row :post_code
        row :phone_number
        row :email
      end
    end

    panel "Ordered Items" do
      table_for order.order_items do
        column "Product Image" do |item|
          if item.product.images.attached?
            image_tag item.product.images.first.url, size: "50x50", style: "border-radius: 5px;" if item.product.images.first.url.present?
          else
            "No Image"
          end
        end
        column :product
        column :quantity
        column "Size" do |item|
          item.size
        end
        column "Price" do |item|
          matched_size = item.product.product_sizes.find_by(size: item.size)
          matched_size ? matched_size.price : "N/A"
        end
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs "Order Details" do
      f.input :user, as: :select, collection: User.all.collect { |u| ["#{u.first_name} #{u.last_name}", u.id] }
      f.input :billing_detail, as: :select, collection: BillingDetail.all.collect { |b| ["#{b.street_address}, #{b.postal_code}", b.id] }, include_blank: "Select Billing Detail"
      f.input :delivery_address, as: :select, collection: DeliveryAddress.all.collect { |d| ["#{d.line1}, #{d.post_code}", d.id] }, include_blank: "Select Delivery Address"
      f.input :total_amount
      f.input :sub_total
      f.input :loyalty_points_used
      f.input :status, as: :select, collection: Order.statuses.keys
      f.input :payment_method, as: :select, collection: Order.payment_methods.keys
      f.input :payment_status, as: :select, collection: Order.payment_statuses.keys
      f.input :consumer_tax
      f.input :shipping
      f.input :delivery_fees
      f.input :coupon_amount
      f.input :coupon_code
    end

    f.inputs "Ordered Items" do
      f.has_many :order_items, allow_destroy: true, new_record: true do |oi|
        oi.input :product, as: :select, collection: Product.all.collect { |p| [p.name, p.id] }
        oi.input :size, as: :select, collection: ProductSize.pluck(:size)
        oi.input :quantity
      end
    end

    f.actions
  end
end
