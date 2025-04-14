class CommentSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :title, :content, :parent_comment_id, :is_liked, :is_disliked, :likes_count, :dislikes_count, :child_comments_count, :created_at, :updated_at, :user, :child_comments

  def child_comments
    ActiveModel::SerializableResource.new(object.child_comments.order(created_at: :asc).limit(5), each_serializer: CommentSerializer, scope: scope)
  end

  def user
    ActiveModel::SerializableResource.new(object.user, serializer: UserSerializer)
  end

  def child_comments_count
    object.child_comments.count
  end

  def is_liked
    current_user_reaction == 'like'
  end

  def is_disliked
    current_user_reaction == 'dislike'
  end

  private

  def current_user_reaction
    return nil unless scope.present?

    object.comment_reactions.find_by(user: scope)&.reaction_type
  end
end
