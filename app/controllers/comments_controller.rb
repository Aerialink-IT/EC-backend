class CommentsController < ApplicationController
  before_action :authenticate_request, unless: -> { action_name == 'index' && request.headers['Authorization'].blank? }
  before_action :set_comment, only: [:update, :destroy]

  def index
    product = Product.find(params[:product_id])
    comments = paginate(product.comments.where(parent_comment_id: nil, approved: true).includes(:child_comments, child_comments: :user).order(created_at: :desc))
    render json: {
      comments: ActiveModelSerializers::SerializableResource.new(comments, each_serializer: CommentSerializer, scope: current_user),
      meta: pagination_meta(comments)
    }
    rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: :not_found
  end

  def create
    comment = current_user.comments.build(comment_params)

    if comment.save
      render json: comment, serializer: CommentSerializer, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @comment.user == current_user && @comment.update(comment_params)
      render json: @comment, serializer: CommentSerializer
    else
      render json: { errors: ["Not authorized or invalid data"] }, status: :forbidden
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      render json: { message: "Comment deleted successfully" }
    else
      render json: { errors: ["Not authorized"] }, status: :forbidden
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Comment not found" }, status: :not_found
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_comment_id, :product_id, :name, :email, :title)
  end
end