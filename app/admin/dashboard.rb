ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.performance_dashboard") }

  content title: proc { I18n.t("active_admin.performance_overview") } do

    columns do
      column do
        panel I18n.t("active_admin.sales_overview") do
          para "#{I18n.t("active_admin.total_revenue")}: $#{Order.sum(:total_amount)}"
          para "#{I18n.t("active_admin.total_orders")}: #{Order.count}"
          para "#{I18n.t("active_admin.profit_margin")}: $#{(Order.sum(:total_amount) - OrderItem.sum(:unit_price)).round(2)}"
        end
      end

      column do
        panel I18n.t("active_admin.customer_activity") do
          para "#{I18n.t("active_admin.total_customers")}: #{User.count}"
          para "#{I18n.t("active_admin.active_customers")}: #{User.where(is_active: true).count}"
          para "#{I18n.t("active_admin.avg_order_value")}: $#{(Order.sum(:total_amount) / Order.count).round(2) rescue 0}"
        end
      end

      column do
        panel I18n.t("active_admin.inventory_levels") do
          para "#{I18n.t("active_admin.total_products")}: #{Product.count}"
          para "#{I18n.t("active_admin.low_stock_products")}: #{Product.where('stock_quantity <= 10').count}"
          para "#{I18n.t("active_admin.out_of_stock_products")}: #{Product.where(stock_quantity: 0).count}"
        end
      end
    end

    columns do
      column do
        panel I18n.t("active_admin.traffic_conversion") do
          para "#{I18n.t("active_admin.total_site_visits")}: 10,000 (Example Data)"
          para "#{I18n.t("active_admin.top_traffic_source")}: Google (Example Data)"
        end
      end
    end

    panel I18n.t("active_admin.sales_trends") do
      line_chart Order.group_by_day(:created_at).sum(:total_amount)
    end

    panel I18n.t("active_admin.top_selling_products") do
      table_for Product.joins(:order_items).group(:id).order('SUM(order_items.quantity) DESC').limit(5) do
        column(I18n.t("active_admin.product")) { |product| product.name }
        column(I18n.t("active_admin.total_sold")) { |product| product.order_items.sum(:quantity) }
      end
    end
  end
end
