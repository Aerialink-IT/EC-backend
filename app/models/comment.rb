class Comment < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :parent_comment, class_name: 'Comment', optional: true
  has_many :child_comments, class_name: 'Comment', foreign_key: 'parent_comment_id', dependent: :destroy
  has_many :comment_reactions, dependent: :destroy

  validates :title, :content, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["parent_comment", "review", "user", "product"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "id_value", "parent_comment_id", "review_id", "updated_at", "user_id", "approved"]
  end

  def likes_count
    comment_reactions.like.count
  end

  def dislikes_count
    comment_reactions.dislike.count
  end
end
