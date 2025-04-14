ActiveAdmin.register_page "Reports" do
  menu priority: 2, label: proc { I18n.t('active_admin.reports.title') }

  content title: I18n.t('active_admin.reports.title') do
    columns do
      column do
        panel I18n.t('active_admin.reports.sales_report') do
          table_for Order.group(:status).count do
            column { |status, count| status }
            column { |status, count| count }
          end
          div do
            pie_chart Order.group(:status).count, title: I18n.t('active_admin.reports.order_status_distribution')
          end
        end
      end

      column do
        panel I18n.t('active_admin.reports.customer_reports') do
          table_for User.joins(:orders).group(:id).order('COUNT(orders.id) DESC').limit(5) do
            column { |user| user.email }
            column { |user| user.orders.count }
          end
          div do
            bar_chart User.joins(:orders).group(:email).order('COUNT(orders.id) DESC').limit(5).count,
                      title: I18n.t('active_admin.reports.top_customers')
          end
        end
      end
    end

    panel I18n.t('active_admin.reports.sales_trends') do
      div do
        line_chart Order.group_by_day(:created_at).sum(:total_amount),
                   title: I18n.t('active_admin.reports.sales_over_time')
      end
    end

    panel I18n.t('active_admin.reports.top_products') do
      table_for Product.joins(:order_items).group(:id).order('SUM(order_items.quantity) DESC').limit(5) do
        column { |product| product.name }
        column { |product| product.order_items.sum(:quantity) }
      end
      div do
        bar_chart Product.joins(:order_items).group(:name).order('SUM(order_items.quantity) DESC').limit(5)
                         .sum('order_items.quantity'),
                  title: I18n.t('active_admin.reports.best_selling_products')
      end
    end
  end
end
