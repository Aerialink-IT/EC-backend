class CommentReactionsController < ApplicationController
  before_action :set_comment, only: [:create, :remove_reaction]

  def create
    reaction = @comment.comment_reactions.find_or_initialize_by(user: current_user)
    reaction.reaction_type = params[:reaction_type]

    if reaction.save
      render json: { message: "Reaction added", reaction: reaction }, status: :ok
    else
      render json: { errors: reaction.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ArgumentError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def remove_reaction
    reaction = @comment.comment_reactions.find_by(user: current_user)

    if reaction&.destroy
      render json: { message: "Reaction removed" }, status: :ok
    else
      render json: { errors: ["Reaction not found"] }, status: :unprocessable_entity
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:comment_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Comment not found" }, status: :not_found
  end
end