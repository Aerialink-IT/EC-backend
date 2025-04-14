class ReviewsController < ApplicationController
  skip_before_action :authenticate_request, only: [:index]
  before_action :set_review, only: [:update, :destroy]

  def index
    product = Product.find(params[:product_id])
    reviews = paginate(product.reviews.includes(:user).order(created_at: :desc))
    render json: {
      reviews: ActiveModelSerializers::SerializableResource.new(reviews, each_serializer: ReviewSerializer),
      meta: pagination_meta(reviews)
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: :not_found
  end

  def create
    review = current_user.reviews.build(review_params)

    if review.save
      render json: review, serializer: ReviewSerializer, status: :created
    else
      render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @review.user == current_user && @review.update(review_params)
      render json: @review, serializer: ReviewSerializer
    else
      render json: { errors: ["Not authorized or invalid data"] }, status: :forbidden
    end
  end

  def destroy
    if @review.user == current_user
      @review.destroy
      render json: { message: "Review deleted successfully" }
    else
      render json: { errors: ["Not authorized"] }, status: :forbidden
    end
  end

  private

  def set_review
    @review = Review.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Review not found" }, status: :not_found
  end

  def review_params
    params.require(:review).permit(:content, :rating, :product_id, :name, :email, images: [])
  end
end
