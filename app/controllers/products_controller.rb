class ProductsController < ApplicationController
  # before_action :authenticate_request, if: -> { request.headers['Authorization'].present? }
  before_action :set_product, only: [:show, :recommended_products]

  def index
    products = params[:query].present? ? Product.search_by_attributes(params[:query]) : Product.all
    if params[:size].present?
      products = products.joins(:product_sizes).where(product_sizes: { size: params[:size] }).distinct
    end

    if params[:sort].present?
      products = products.order(price: params[:sort] == 'low_to_high' ? :asc : :desc)
    end

    if params[:category_id].present?
      category = Category.find_by(uuid: params[:category_id])
      if category
        category_ids = category.subcategories.pluck(:id) << category.id
        products = products.joins(:categories).where(categories: { id: category_ids })
      else
        render json: { error: "Category not found" }, status: :not_found and return
      end
    end

    products = paginate(products.order(created_at: :asc))

    render json: {
      products: ActiveModelSerializers::SerializableResource.new(products, each_serializer: ProductSerializer, scope: current_user),
      meta: pagination_meta(products)
    }
  end

  def show
    render json: @product
  end

  def recommended_products
    category_ids = @product.categories.pluck(:id)
    same_category_products = Product.joins(:categories)
                                    .where(categories: { id: category_ids })
                                    .where.not(id: @product.id)
                                    .limit(5)

    search_query = "#{@product.name} #{@product.description}"
    similar_products = Product.search_by_attributes(search_query)
                              .where.not(id: @product.id)
                              .limit(5)

    products = (same_category_products + similar_products).uniq.first(5)

    render json: products
  end

  def purchased_product
    product = Product.find_by(id: params[:product_id])
  
    unless product
      return render json: { error: "Product not found" }, status: :not_found
    end
    purchased = Order.joins(:order_items) .where(user: current_user, status: "delivered", order_items: { product_id: product.id }).exists?
    render json: { product_id: product.id, purchased: purchased }
  end

  private

  def set_product
    @product = Product.find_by!(uuid: params[:uuid])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: :not_found
  end
end
