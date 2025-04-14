class CommentReaction < ApplicationRecord
  belongs_to :comment
  belongs_to :user

  validates :reaction_type, presence: true

  enum reaction_type: { like: 0, dislike: 1 }

  validates :user_id, uniqueness: { scope: :comment_id, message: "User can only react once per comment" }
end
